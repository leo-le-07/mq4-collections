//+------------------------------------------------------------------+
//|                                              Buy with SL and TP |
//|                               Copyright © 2018, Leo             |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2018, Leo"
#property link      "mr.leo.1509@gmail.com"
#include <stdlib.mqh>

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() { 
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
//+------------------------------------------------------------------+

