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

double stop_lost = 10;
double take_profit = 10;
double step_adjust = 0.05;
double lots = 0.3;
double max_lots = 2;
double min_lots = 0;

void OnTick() {
  DrawLabel("intro", "FOMO by LEO", clrOrangeRed, 1);
  DrawLabel("lots", "Lots size: " + DoubleToString(lots,2), clrGreenYellow, 2);
  DrawLabel("command_1", "Adjust lots (0.05 per step): (I)ncrease, (R)educe", clrGreenYellow, 4);
  DrawLabel("command_2", "Commands: (B)uy, (S)ell, B(u)y Limit, S(e)ll Limit, (C)lose All", clrGreenYellow, 3);
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
          CloseAll();
          break;
        case 82: // R
          ReduceLots(lots, step_adjust);
          break;
        case 73: // I
          IncreaseLots(lots, step_adjust);
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

void CloseAll() {
  int totalOrders = OrdersTotal(), i, iError;
  bool ok;

  if (totalOrders == 0) {
    Print("=== No order found");
    return;
  }

  for(i = totalOrders - 1; i >= 0; i--) {
    if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
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
  if (lots <= min_lots) {
    Print("Reach minimum lots size");
    lots = min_lots;
  }
  else {
    lots -= step_adjust;
  }
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
  ObjectSet(id, OBJPROP_YDISTANCE, 3 + (y_order * 10));
}

//+------------------------------------------------------------------+

