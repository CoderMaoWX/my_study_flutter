class TestMo {
  String? id;
  String? vid;
  String? title;
  String? tname;
  String? url;
  String? cover;
  int? pubdate;
  String? desc;
  int? view;
  int? duration;
  Owner? owner;
  int? reply;
  int? favorite;
  int? like;
  int? coin;
  int? share;
  String? createTime;
  int? size;

  TestMo(
      {this.id,
      this.vid,
      this.title,
      this.tname,
      this.url,
      this.cover,
      this.pubdate,
      this.desc,
      this.view,
      this.duration,
      this.owner,
      this.reply,
      this.favorite,
      this.like,
      this.coin,
      this.share,
      this.createTime,
      this.size});

  TestMo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vid = json['vid'];
    title = json['title'];
    tname = json['tname'];
    url = json['url'];
    cover = json['cover'];
    pubdate = json['pubdate'];
    desc = json['desc'];
    view = json['view'];
    duration = json['duration'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    reply = json['reply'];
    favorite = json['favorite'];
    like = json['like'];
    coin = json['coin'];
    share = json['share'];
    createTime = json['createTime'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vid'] = vid;
    data['title'] = title;
    data['tname'] = tname;
    data['url'] = url;
    data['cover'] = cover;
    data['pubdate'] = pubdate;
    data['desc'] = desc;
    data['view'] = view;
    data['duration'] = duration;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    data['reply'] = reply;
    data['favorite'] = favorite;
    data['like'] = like;
    data['coin'] = coin;
    data['share'] = share;
    data['createTime'] = createTime;
    data['size'] = size;
    return data;
  }
}

class Owner {
  String? name;
  String? face;
  int? fans;

  Owner({this.name, this.face, this.fans});

  Owner.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    face = json['face'];
    fans = json['fans'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['face'] = face;
    data['fans'] = fans;
    return data;
  }
}
