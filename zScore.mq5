//+------------------------------------------------------------------+
//|                                                      zscore1.mq5 |
//|                                                            Jatin |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
#property indicator_buffers 2
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1  DodgerBlue
#property indicator_label1  "Z score"

input int len = 75; // Length parameter for SMA and STD
double ZScoreBuffer[];

int OnInit()
  {
//--- indicator buffers mapping

   // Set indicator buffers
   SetIndexBuffer(0, ZScoreBuffer);

   // Set indicator label
   IndicatorSetString(INDICATOR_SHORTNAME, "Z-Score");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {   
  Print(rates_total);
      // Calculate Z-Score
      for (int i = 0;i<rates_total;i++)
      {
      double sum = 0;
      for(int j=0;j<len && i-j>=0;j++){
         sum+=close[i-j];
      }
      
      double mean = sum / len;
      double sum_sq_diff = 0;
      for(int j=0;j<len && i-j>=0;j++){
         sum+=close[i-j];
         sum_sq_diff += MathPow(close[i-j] - mean, 2);
      }
      
      double stdDev = MathSqrt(sum_sq_diff/len);
     
         ZScoreBuffer[i] = (close[i] - mean) / stdDev;
         if(ZScoreBuffer[i]<1 && ZScoreBuffer[i]> -1){
         
            ZScoreBuffer[i] = 0;
         }
      }

   return rates_total - len;
//--- return value of prev_calculated for next call
  }
