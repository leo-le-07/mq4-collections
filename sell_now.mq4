//+------------------------------------------------------------------+
//|                                              Buy with SL and TP |
//|                               Copyright © 2018, Leo             |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2018, Leo"
#property link      "mr.leo.1509@gmail.com"


// #property show_inputs

double Lots = 0.3;
double StopLoss = 10;
double TakeProfit = 10;
double Entry = 0.0000; // Leave 0 value means that we place Market order


//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  { 
  int Mode = OP_SELL;
  if (Bid < Entry && Entry > 0) Mode = OP_SELLLIMIT; 
  if (Entry == 0) Entry = Bid;
  double SLB = Entry + StopLoss*10*Point, TPB = Entry - TakeProfit*10*Point;
  if(Lots > 0)
    {
      OrderSend(Symbol(),Mode, Lots, Entry, 2,SLB , TPB, "Sell Script", 0, NULL, CLR_NONE);
    }
  }
//+------------------------------------------------------------------+

