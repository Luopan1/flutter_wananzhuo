class HotKey {

  /**
   * errorMsg : ""
   * errorCode : 0
   * data : [{"id":6,"link":"","name":"面试","order":1,"visible":1},{"id":9,"link":"","name":"Studio3","order":1,"visible":1},{"id":5,"link":"","name":"动画","order":2,"visible":1},{"id":1,"link":"","name":"自定义View","order":3,"visible":1},{"id":2,"link":"","name":"性能优化 速度","order":4,"visible":1},{"id":3,"link":"","name":"gradle","order":5,"visible":1},{"id":4,"link":"","name":"Camera 相机","order":6,"visible":1},{"id":7,"link":"","name":"代码混淆 安全","order":7,"visible":1},{"id":8,"link":"","name":"逆向 加固","order":8,"visible":1}]
   */

  String errorMsg;
  int errorCode;
  List<DataListBean> data;

  static HotKey fromMap(Map<String, dynamic> map) {
    HotKey hot_key = new HotKey();
    hot_key.errorMsg = map['errorMsg'];
    hot_key.errorCode = map['errorCode'];
    hot_key.data = DataListBean.fromMapList(map['data']);
    return hot_key;
  }

  static List<HotKey> fromMapList(dynamic mapList) {
    List<HotKey> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

}

class DataListBean {

  /**
   * link : ""
   * name : "面试"
   * id : 6
   * order : 1
   * visible : 1
   */

  String link;
  String name;
  int id;
  int order;
  int visible;

  static DataListBean fromMap(Map<String, dynamic> map) {
    DataListBean dataListBean = new DataListBean();
    dataListBean.link = map['link'];
    dataListBean.name = map['name'];
    dataListBean.id = map['id'];
    dataListBean.order = map['order'];
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
