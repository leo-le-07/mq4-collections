//+------------------------------------------------------------------+
//|                                              Buy with SL and TP |
//|                               Copyright © 2018, Leo             |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2018, Leo"
#property link      "mr.leo.1509@gmail.com"


#property show_inputs

double Lots = 0.3;
double StopLoss = 10;
double TakeProfit = 10;
extern double Entry = Bid;


//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  { 
  double SLB = Entry + StopLoss*10*Point, TPB = Entry - TakeProfit*10*Point;
  if(Lots > 0 && Entry > Bid)
    {
      int Mode = OP_SELLLIMIT;
      OrderSend(Symbol(),Mode, Lots, Entry, 2,SLB , TPB, "Sell Script", 0, NULL, CLR_NONE);
    }
  }
//+------------------------------------------------------------------+

