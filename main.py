#encoding: utf-8

import sys
import time

reload(sys)
sys.setdefaultencoding('utf-8')

from services.stock.StockService import StockService
from services.stock.StockCrawlerService import StockCrawlerService
from models.stock.StockBaseModel import StockBaseModel
from models.stock.StockModel import StockModel


def crawStocks():
	StockCrawlerService.fetchAllStockBaseModelsFromInternet()


def crawStockDaily(date):
	l = StockService.getAllFailedDailyStockBaseModels(date)
	maxLoops = 2
	while len(l) > 0 and maxLoops > 0:
		for model in l:
			StockCrawlerService.fetchDailyStockModelFromInternet(model)

		l = StockService.getAllFailedDailyStockBaseModels(date)

		maxLoops = maxLoops - 1

def crawStockDailyTrade(date):
	l = StockService.getAllFailedDailyTradeStockBaseModels(date)
	print l
	maxLoops = 1
	while len(l) > 0 and maxLoops > 0:
		for model in l:
			StockCrawlerService.fetchStockTradeInfoFromInternet(model, date)

		l = StockService.getAllFailedDailyTradeStockBaseModels(date)
		maxLoops = maxLoops - 1


def lastTradeDate():
	today = time.localtime()
	if today.tm_wday > 4:
		today = time.localtime(time.time() - 3600 * 24 * (today.tm_wday - 4))
	return today


if __name__ == '__main__':
 	today = time.strftime("%Y-%m-%d", lastTradeDate())
	print today

	crawStocks()
	crawStockDaily(today)
	crawStockDailyTrade(today)
