# -*- coding: utf-8 -*-
#!usr/bin/python2
import scrapy

class SouqSpider(scrapy.Spider):
    name = "Souq"  # Name of the Spider, required value
    start_urls = ["http://deals.souq.com/ae-en/tag/9109"]  # The starting url, Scrapy will request this URL in parse

    # Entry point for the spider
    def parse(self, response):
        for href in response.css('.sp-cms_unit--ttl a::attr(href)'):
            url = href.extract()
