class WeChatData {

  /**
   * errorMsg : ""
   * errorCode : 0
   * data : [{"children":[],"courseId":13,"id":408,"name":"鸿洋","order":190000,"parentChapterId":407,"userControlSetTop":false,"visible":1},{"children":[],"courseId":13,"id":409,"name":"郭霖","order":190001,"parentChapterId":407,"userControlSetTop":false,"visible":1},{"children":[],"courseId":13,"id":410,"name":"玉刚说","order":190002,"parentChapterId":407,"userControlSetTop":false,"visible":1},{"children":[],"courseId":13,"id":411,"name":"承香墨影","order":190003,"parentChapterId":407,"userControlSetTop":false,"visible":1},{"children":[],"courseId":13,"id":413,"name":"Android群英传","order":190004,"parentChapterId":407,"userControlSetTop":false,"visible":1},{"children":[],"courseId":13,"id":414,"name":"code小生","order":190005,"parentChapterId":407,"userControlSetTop":false,"visible":1},{"children":[],"courseId":13,"id":415,"name":"谷歌开发者","order":190006,"parentChapterId":407,"userControlSetTop":false,"visible":1},{"children":[],"courseId":13,"id":416,"name":"奇卓社","order":190007,"parentChapterId":407,"userControlSetTop":false,"visible":1},{"children":[],"courseId":13,"id":417,"name":"美团技术团队","order":190008,"parentChapterId":407,"userControlSetTop":false,"visible":1},{"children":[],"courseId":13,"id":420,"name":"GcsSloop","order":190009,"parentChapterId":407,"userControlSetTop":false,"visible":1},{"children":[],"courseId":13,"id":421,"name":"互联网侦察","order":190010,"parentChapterId":407,"userControlSetTop":false,"visible":1},{"children":[],"courseId":13,"id":427,"name":"susion随心","order":190011,"parentChapterId":407,"userControlSetTop":false,"visible":1},{"children":[],"courseId":13,"id":428,"name":"程序亦非猿","order":190012,"parentChapterId":407,"userControlSetTop":false,"visible":1}]
   */

  String errorMsg;
  int errorCode;
  List<DataListBean> data;

  static WeChatData fromMap(Map<String, dynamic> map) {
    WeChatData weChatData = new WeChatData();
    weChatData.errorMsg = map['errorMsg'];
    weChatData.errorCode = map['errorCode'];
    weChatData.data = DataListBean.fromMapList(map['data']);
    return weChatData;
  }

  static List<WeChatData> fromMapList(dynamic mapList) {
    List<WeChatData> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

}

class DataListBean {

  /**
   * name : "鸿洋"
   * userControlSetTop : false
   * courseId : 13
   * id : 408
   * order : 190000
   * parentChapterId : 407
   * visible : 1
   */

  String name;
  bool userControlSetTop;
  int courseId;
  int id;
  int order;
  int parentChapterId;
  int visible;

  static DataListBean fromMap(Map<String, dynamic> map) {
    DataListBean dataListBean = new DataListBean();
    dataListBean.name = map['name'];
    dataListBean.userControlSetTop = map['userControlSetTop'];
    dataListBean.courseId = map['courseId'];
    dataListBean.id = map['id'];
    dataListBean.order = map['order'];
    dataListBean.parentChapterId = map['parentChapterId'];
    dataListBean.visible = map['visible'];
    return dataListBean;
  }

  static List<DataListBean> fromMapList(dynamic mapList) {
    List<DataListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
