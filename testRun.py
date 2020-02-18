#import external pandas_datareader library
import pandas_datareader as web

#import datatime internal datetime module
import datetime

#read ticker symbols from a file to python symbol list
symbol = []
with open('D:\python_programs\Gaps.txt') as f:
    for line in f:
        symbol.append(line.strip())
f.close

#datetime.datetime is a data type within the datetime module
end = datetime.datetime.today()
start = datetime.date(end.month-4,1,1)

#invoke to csv for df datafrime object from DataReader method in pandas_datareader
path_out = 'd:/python_programs_output/'

# loop through tickers
i = 0
while i<len(symbol):
    try:
        df = web.DataReader(symbol[i],'yahoo',start,end)
        df.insert(0,'Symbol',symbol[i])
        df = df.drop(['Adj Close'], axis=1)
        if i == 0:
            df.to_csv(path_out+'yahoo_prices_volumes_for_Gaps.csv')
            print (i,symbol[i],'has data stored to csv file')
        else:
            df.to_csv(path_out+'yahoo_prices_volumes_for_Gaps.csv',mode = 'a',header = False)
            print (i,symbol[i],'has data stored to csv file')
    except:
        print("No information for ticker # and symbol:")
        print (i,symbol[i])
        continue
    i = i+1
