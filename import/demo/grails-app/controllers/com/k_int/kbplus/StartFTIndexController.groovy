package com.k_int.kbplus

class StartFTIndexController {

  def dataloadService

  def index() { 
    log.debug("manual start full text index");
    dataloadService.updateFTIndexes();
  }
}
