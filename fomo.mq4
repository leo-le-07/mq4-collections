//+------------------------------------------------------------------+
//|                                                         fomo.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <stdlib.mqh>

const double default_stop_lost = 10;
const double default_take_profit = 10;
const double step_adjust = 0.05;
const double default_lots = 0.3;
const double max_lots = 2;
const double min_lots = 0.01;

double stop_lost = default_stop_lost;
double take_profit = default_take_profit;
double lots = default_lots;

void OnTick() {
  DrawLabel("lots", "Lots size: " + DoubleToString(lots,2) + ". SL: -" + DoubleToString(stop_lost, 0) + " pips" + ". TP: +" + DoubleToString(take_profit, 0) + " pips", clrFireBrick, 0);
  DrawLabel("command_1", "Adjust lots (0.05): (I)ncrease, (R)educe", clrFireBrick, 1);
  DrawLabel("command_2", "SL/TP: Increase SL(1), Reduce SL(2), Increase TP(3), Reduce TP(4)", clrFireBrick, 2);
  DrawLabel("command_3", "(B)uy, (S)ell, B(u)y Limit, S(e)ll Limit", clrFireBrick, 3);
  DrawLabel("command_4", "(C)lose, C(X)lose All, Reset(0)", clrFireBrick, 4);
}

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam) {
  switch(id) {
    case CHARTEVENT_KEYDOWN:
      // Print("=== Press: "+lparam);
      switch(int(lparam)) {
        case 66: // B
          Buy(lots, take_profit, stop_lost);
          break;
        case 85: // U
          BuyLimit(lots, take_profit, stop_lost);
          break;
        case 67: // C
          Close();
          break;
        case 88: // X
          CloseAll();
          break;
        case 82: // R
          ReduceLots(lots, step_adjust);
          break;
        case 73: // I
          IncreaseLots(lots, step_adjust);
          break;
        case 48: // 0
          ResetParams();
          break;
        case 49: // 1
          IncreaseSL();
          break;
        case 50: // 2
          ReduceSL();
          break;
        case 51: // 3
          IncreaseTP();
          break;
        case 52: // 4
          ReduceTP();
          break;
        case 83: // S
        Sell(lots, take_profit, stop_lost);
          break;
        case 69: // E
        SellLimit(lots, take_profit, stop_lost);
          break;
        default: Print("=== Pressed key has not supported");
      }
      Print("=== Lots size: " + lots);
      break;
  }
}

void IncreaseSL() {
  stop_lost += 2;
}

void ReduceSL() {
  stop_lost -= 2;
}

void IncreaseTP() {
  take_profit +=2;
}

void ReduceTP() {
  take_profit -=2;
}

void ResetParams() {
  stop_lost = default_stop_lost;
  take_profit = default_take_profit;
  lots = default_lots;
}

void Buy(double lots, double take_profit, double stop_lost) {
  double entry = Ask;
  double stoploss = entry - stop_lost*10*Point;
  double takeprofit = entry + take_profit*10*Point;
  int mode = OP_BUY;
  int slippage = 2;
  int result = OrderSend(Symbol(), mode, lots, entry, slippage, stoploss, takeprofit, "Buy Script", 0, NULL, CLR_NONE);
  if (result == -1) {
    Print("=== Buy order failed: ", GetLastError());
  } else {
    Print("=== Buy order successfully: ");
  }
}

void BuyLimit(double lots, double take_profit, double stop_lost) {
  double entry = Ask - 10 * 10 * Point;
  double stoploss = entry - stop_lost*10*Point;
  double takeprofit = entry + take_profit*10*Point;
  int mode = OP_BUYLIMIT;
  int slippage = 2;
  int result = OrderSend(Symbol(), mode, lots, entry, slippage, stoploss, takeprofit, "Buy Limit Script", 0, NULL, CLR_NONE);
  if (result == -1) {
    Print("=== Buy limit order failed: ", GetLastError());
  } else {
    Print("=== Buy limit order successfully: ");
  }
}

void Sell(double lots, double take_profit, double stop_lost) {
  double entry = Bid;
  double stoploss = entry + stop_lost*10*Point;
  double takeprofit = entry - take_profit*10*Point;
  int mode = OP_SELL;
  int slippage = 2;
  int result = OrderSend(Symbol(), mode, lots, entry, slippage, stoploss, takeprofit, "Sell Script", 0, NULL, CLR_NONE);
  if (result == -1) {
    Print("=== Sell order failed: ", GetLastError());
  } else {
    Print("=== Sell order successfully: ");
  }
}

void SellLimit(double lots, double take_profit, double stop_lost) {
  double entry = Bid + 10 * 10 * Point;
  double stoploss = entry + stop_lost*10*Point;
  double takeprofit = entry - take_profit*10*Point;
  int mode = OP_SELLLIMIT;
  int slippage = 2;
  int result = OrderSend(Symbol(), mode, lots, entry, slippage, stoploss, takeprofit, "Sell Limit Script", 0, NULL, CLR_NONE);
  if (result == -1) {
    Print("=== Sell limit order failed: ", GetLastError());
  } else {
    Print("=== Sell limit order successfully: ");
  }
}

void _Close(bool isCloseAll=false) {
  int totalOrders = OrdersTotal(), i, iError;
  bool ok;
  string currentSymbol = Symbol();

  if (totalOrders == 0) {
    Print("=== No order found");
    return;
  }

  for(i = totalOrders - 1; i >= 0; i--) {
    if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (!isCloseAll && currentSymbol != OrderSymbol()) continue; // only close order of in current window

      switch(OrderType()) {
        case OP_BUY:
          ok = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5);
          break;
        case OP_SELL:
          ok = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5);
          break;
        case OP_BUYLIMIT:
        case OP_SELLLIMIT:
        case OP_BUYSTOP:
        case OP_SELLSTOP:
          ok = OrderDelete(OrderTicket());
          break;
      }
      if (!ok) {
        iError = GetLastError();
        Print("=== Order: ", OrderTicket(), ". Error: ", iError, " ", ErrorDescription(iError));
      }
    }
    else {
      Print("=== Cannot select order: ", ErrorDescription(iError));
    }
  }
}

void Close() {
  _Close();
}

void CloseAll() {
  _Close(true);
}

void IncreaseLots(double &lots, const double step_adjust) {
  if (lots >= max_lots) {
    Print("Reach maximum lots size");
    lots = max_lots;
  }
  else {
    lots += step_adjust;
  }
}

void ReduceLots(double &lots, const double step_adjust) {
  if (lots > min_lots && lots - step_adjust <= 0.05) {
    Print("here lots: ", lots);
    lots -= 0.01;
    return;
  }
  if (lots - step_adjust <= min_lots) {
    Print("Reach minimum lots size");
    lots = min_lots;
    return;
  }
  Print("finally here lots: ", lots);
  lots -= step_adjust;
}

void DrawLabel(string id, string text, color text_color, int y_order) {
  int font_size = 8;
  string font_name = "Arial";
  int corner = CORNER_LEFT_UPPER;
  int x_points = 0;
  ObjectCreate(id, OBJ_LABEL, 0, 0, 0);
  ObjectSetText(id, text, font_size, font_name, text_color);
  ObjectSet(id, OBJPROP_CORNER, corner);
  ObjectSet(id, OBJPROP_XDISTANCE, x_points + 10);
  ObjectSet(id, OBJPROP_YDISTANCE, ((2 * y_order) + 1) * 10);
}

//+------------------------------------------------------------------+

