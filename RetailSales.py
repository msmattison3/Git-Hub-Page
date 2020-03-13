# -*- coding: utf-8 -*-
"""
Created on Mon Feb 17 15:34:07 2020

@author: Colepink3
"""
from mrjob.job import MRJob
from mrjob.step import MRStep

class MRRetailSales(MRJob):

      def steps(self):
          return [
            MRStep(mapper=self.mapper_get_sales,                               
                   reducer=self.reducer_group_sales),
            MRStep(mapper=self.mapper_greater,
                   reducer=self.reducer_all_greater),                            
            MRStep(mapper=self.mapper_format_sales,                                                                               
                   reducer=self.reducer_sales_sml_to_lrg),
      ]            
  
      def mapper_get_sales(self, key, line):
         (NAICSID, description, num_establishment, sales) = line.split(',')     
         yield (description, float(sales)), 1                                     
        
      def reducer_group_sales(self, key, value):
          yield key, sum(value)  
       
      def mapper_greater(self, key, occurences):
          yield key[0], (key[1], occurences)
       
      def reducer_all_greater(self, key, value): 
          total = 0
          count = 0
          for val in value:
              total += val[0]*val[1]
              count += val[1]
          if total > 1000000000:
             yield key, total
   
      def mapper_format_sales(self, description, total,):                                 
          yield '$ {:,.2f}'.format(total), description
        
      def reducer_sales_sml_to_lrg(self, total, description):        
           yield (description, total)
       
if __name__ == '__main__':
    MRRetailSales.run()

## Execution Statement
# !python RetailSales.py RetailSalesA1.csv 
