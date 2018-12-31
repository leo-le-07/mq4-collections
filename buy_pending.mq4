//+------------------------------------------------------------------+
//|                                              Buy with SL and TP |
//|                               Copyright © 2018, Leo             |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2018, Leo"
#property link      "mr.leo.1509@gmail.com"


#property show_inputs

double StopLoss = 10;
double TakeProfit = 10;
extern double Entry = 0.0000;
extern double Lots = 0.3;


//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
  double SLB = Entry - StopLoss*10*Point, TPB = Entry + TakeProfit*10*Point;
  if(Lots > 0 && Entry < Ask && Entry > 0)
    {
      int Mode = OP_BUYLIMIT;
      OrderSend(Symbol(), Mode, Lots, Entry, 2, SLB , TPB, "Buy Script", 0, NULL, CLR_NONE);
    }
  }
//+------------------------------------------------------------------+
