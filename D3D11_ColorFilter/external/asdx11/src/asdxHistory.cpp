//-----------------------------------------------------------------------------
// File : asdxHistory.cpp
// Desc : History Module.
// Copyright(c) Project Asura. All right reserved.
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Includes
//-----------------------------------------------------------------------------
#include <algorithm>
#include <cassert>
#include <asdxHistory.h>
#include <asdxLogger.h>


namespace asdx {

///////////////////////////////////////////////////////////////////////////////
// EventHandler class
///////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
//      コンストラクタです.
//-----------------------------------------------------------------------------
EventHandler::EventHandler()
{ /* DO_NOTHING */ }

//-----------------------------------------------------------------------------
//      デストラクタです.
//-----------------------------------------------------------------------------
EventHandler::~EventHandler()
{ m_Listeners.clear(); }

//-----------------------------------------------------------------------------
//      呼び出しを行います.
//-----------------------------------------------------------------------------
void EventHandler::Invoke()
{
    for(auto& itr : m_Listeners)
    { itr->OnNotify(); }
}

//-----------------------------------------------------------------------------
//      追加登録します.
//-----------------------------------------------------------------------------
EventHandler& EventHandler::operator += (IEventListener* listener)
{
    m_Listeners.push_back(listener);
    return *this;
}

//-----------------------------------------------------------------------------
//      登録削除します.
//-----------------------------------------------------------------------------
EventHandler& EventHandler::operator-= (IEventListener* listener)
{
    std::remove(m_Listeners.begin(), m_Listeners.end(), listener);
    return *this;
}


///////////////////////////////////////////////////////////////////////////////
// History class
///////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
//      コンストラクタです.
//-----------------------------------------------------------------------------
History::History(Action redo, Action undo)
: m_Redo(redo)
, m_Undo(redo)
{ /* DO_NOTHING */ }

//-----------------------------------------------------------------------------
//      デストラクタです.
//-----------------------------------------------------------------------------
History::~History()
{ /* DO_NOTHING */ }

//-----------------------------------------------------------------------------
//      やり直しします.
//-----------------------------------------------------------------------------
void History::Redo()
{
    assert(m_Redo != nullptr);
    m_Redo();
}

//-----------------------------------------------------------------------------
//      元に戻します.
//-----------------------------------------------------------------------------
void History::Undo()
{
    assert(m_Redo != nullptr);
    m_Undo();
}


///////////////////////////////////////////////////////////////////////////////
// GroupHistory class
///////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
//      コンストラクタです.
//-----------------------------------------------------------------------------
GroupHistory::GroupHistory()
{ /* DO_NOTHING */ }

//-----------------------------------------------------------------------------
//      デストラクタです.
//-----------------------------------------------------------------------------
GroupHistory::~GroupHistory()
{ Clear(); }

//-----------------------------------------------------------------------------
//      ヒストリーを追加します.
//-----------------------------------------------------------------------------
void GroupHistory::Add(IHistory* item)
{
    assert(item != nullptr);
    m_Histories.push_back(item);
}

//-----------------------------------------------------------------------------
//      ヒストリーを全て削除します.
//-----------------------------------------------------------------------------
void GroupHistory::Clear()
{
    auto itr = std::begin(m_Histories);
    while(itr != std::end(m_Histories))
    {
        auto ptr = (*itr);
        if (ptr != nullptr)
        { delete ptr; }

        itr = m_Histories.erase(itr);
    }

    m_Histories.clear();
}

//-----------------------------------------------------------------------------
//      ヒストリーが空かどうか判定します.
//-----------------------------------------------------------------------------
bool GroupHistory::IsEmpty() const
{ return m_Histories.empty(); }

//-----------------------------------------------------------------------------
//      ヒストリー数を取得します.
//-----------------------------------------------------------------------------
int GroupHistory::GetCount() const
{ return int(m_Histories.size()); }

//-----------------------------------------------------------------------------
//      元に戻します.
//-----------------------------------------------------------------------------
void GroupHistory::Undo()
{
    auto itr = std::rbegin(m_Histories);
    while(itr != std::rend(m_Histories))
    {
        (*itr)->Undo();
        itr++;
    }
    UndoExecuted.Invoke();
}

//-----------------------------------------------------------------------------
//      やり直します.
//-----------------------------------------------------------------------------
void GroupHistory::Redo()
{
    for(auto& itr : m_Histories)
    { itr->Redo(); }
    RedoExecuted.Invoke();
}

///////////////////////////////////////////////////////////////////////////////
// HistoryMgr class
///////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
//      コンストラクタです.
//-----------------------------------------------------------------------------
HistoryMgr::HistoryMgr()
: m_Current(0)
{ /* DO_NOTHING */ }

//-----------------------------------------------------------------------------
//      デストラクタです.
//-----------------------------------------------------------------------------
HistoryMgr::~HistoryMgr()
{ Term(); }

//-----------------------------------------------------------------------------
//      初期化済みかチェックします.
//-----------------------------------------------------------------------------
bool HistoryMgr::IsInit() const
{ return m_Init; }

//-----------------------------------------------------------------------------
//      初期化処理を行います.
//-----------------------------------------------------------------------------
bool HistoryMgr::Init(int capacity)
{
    std::lock_guard<std::recursive_mutex> gurad(m_Mutex);

    if (m_Init)
    { return false; }

    if (capacity <= 0)
    { return false; }

    m_Histories.reserve(capacity);
    m_Init      = true;
    m_Current   = 0;
    m_Capacity  = capacity;

    return true;
}

//-----------------------------------------------------------------------------
//      終了処理を行います.
//-----------------------------------------------------------------------------
void HistoryMgr::Term()
{
    std::lock_guard<std::recursive_mutex> gurad(m_Mutex);

    auto itr = std::begin(m_Histories);
    while(itr != std::end(m_Histories))
    {
        auto ptr = (*itr);
        if (ptr != nullptr)
        { delete ptr; }
        itr = m_Histories.erase(itr);
    }
    m_Histories.clear();
    m_Init = false;
}

//-----------------------------------------------------------------------------
//      現在のインデックスを取得します.
//-----------------------------------------------------------------------------
int HistoryMgr::GetCurrent() const
{ return m_Current; }

//-----------------------------------------------------------------------------
//      Undo回数を取得します.
//-----------------------------------------------------------------------------
int HistoryMgr::GetUndoCount() const
{ return m_Current; }

//-----------------------------------------------------------------------------
//      Redo回数を取得します.
//-----------------------------------------------------------------------------
int HistoryMgr::GetRedoCount() const
{ return int(m_Histories.size()) - m_Current; }

//-----------------------------------------------------------------------------
//      Redoできるかチェックします.
//-----------------------------------------------------------------------------
bool HistoryMgr::CanRedo() const
{ return size_t(m_Current) < m_Histories.size(); }

//-----------------------------------------------------------------------------
//      Undoできるかチェックします.
//-----------------------------------------------------------------------------
bool HistoryMgr::CanUndo() const
{ return 0 < m_Current; }

//-----------------------------------------------------------------------------
//      ヒストリーが空であるかチェックします.
//-----------------------------------------------------------------------------
bool HistoryMgr::IsEmpty() const
{ return m_Histories.empty(); }

//-----------------------------------------------------------------------------
//      ヒストリーを追加します.
//-----------------------------------------------------------------------------
void HistoryMgr::Add(IHistory* item, bool redo)
{
    std::lock_guard<std::recursive_mutex> gurad(m_Mutex);

    assert(m_Init == true);
    assert(item != nullptr);

    if (redo)
    { item->Redo(); }

    auto count = int(m_Histories.size()) - m_Current;
    if (count > 0)
    {
        auto start = std::begin(m_Histories) + m_Current;
        auto end   = start + count;

        auto itr = start;
        while(itr != end)
        {
            auto ptr = (*itr);
            itr++;
            delete ptr;
        }
        m_Histories.erase(start, end);
    }

    m_Histories.push_back(item);
    ++m_Current;
}

//-----------------------------------------------------------------------------
//      ヒストリーを全削除します.
//-----------------------------------------------------------------------------
void HistoryMgr::Clear()
{
    std::lock_guard<std::recursive_mutex> gurad(m_Mutex);

    auto itr = std::begin(m_Histories);
    while(itr != std::end(m_Histories))
    {
        auto ptr = (*itr);
        if (ptr != nullptr)
        { delete ptr; }
        itr = m_Histories.erase(itr);
    }
    m_Histories.clear();
    m_Histories.reserve(m_Capacity); // やらなくて大丈夫なはずだけども念のため.
    m_Current = 0;
}

//-----------------------------------------------------------------------------
//     やり直しします.
//-----------------------------------------------------------------------------
void HistoryMgr::Redo()
{
    std::lock_guard<std::recursive_mutex> gurad(m_Mutex);

    assert(m_Init == true);
    m_Histories[m_Current]->Redo();
    ++m_Current;
    RedoExecuted.Invoke();
}

//-----------------------------------------------------------------------------
//      元に戻します.
//-----------------------------------------------------------------------------
void HistoryMgr::Undo()
{
    std::lock_guard<std::recursive_mutex> gurad(m_Mutex);

    assert(m_Init == true);
    --m_Current;
    m_Histories[m_Current]->Undo();
    UndoExecuted.Invoke();
}

} // namespace asdx
