import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import '../screens/teamScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';

final String token = '782ed62cefb14d55b5eb4a99e48c88ab';

class LeagueStanding extends StatefulWidget {
  String leagueCode;
  String leagueName;
  Color leagueColor;
  LeagueStanding(this.leagueCode, this.leagueName, this.leagueColor);

  @override
  createState() => LeagueStandingState(leagueCode, leagueName, leagueColor);
}

class LeagueStandingState extends State<LeagueStanding> {
  String leagueCode;
  String leagueName;
  Color leagueColor;
  LeagueStandingState(this.leagueCode, this.leagueName, this.leagueColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: leagueColor),
      //backgroundColor: leagueColor,
      //appBar: AppBar(title: Text(leagueName), backgroundColor: leagueColor,),
      child: FutureBuilder(
        future: getLeagueStandings(leagueCode),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: <Widget>[
                Padding(
                  child: rankingRow(''),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                ),
                Divider(
                  color: Colors.white,
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: Divider(
                          color: Colors.white,
                          height: 15,
                        ),
                      );
                    },
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return Container(
                        decoration: BoxDecoration(
                          color: leagueColor.withOpacity(0),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        //padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: rankingRow(
                            snapshot.data[i].pos.toString(),
                            snapshot.data[i].teamInfo['name'],
                            snapshot.data[i].pts.toString(),
                            snapshot.data[i].playedGames.toString(),
                            snapshot.data[i].w.toString(),
                            snapshot.data[i].d.toString(),
                            snapshot.data[i].l.toString(),
                            context,
                            snapshot.data[i].teamInfo['id']),
                      );
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}

Widget rankingRow(
    [String p = 'Pos',
    String t = 'Team',
    String pts = 'Pts',
    String mp = 'MP',
    String w = 'W',
    String d = 'D',
    String l = 'L',
    BuildContext ctx,
    int id]) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          ctx, MaterialPageRoute(builder: (ctx) => TeamScreen(id, t)));
    },
    child: Row(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Text(p, style: plStyle),
          ),
          flex: 1,
        ),
        Expanded(
          child: Text(t, style: plStyle),
          flex: 4,
        ),
        Expanded(
          child: Text(mp, style: plStyle),
          flex: 1,
        ),
        Expanded(
          child: Text(w, style: plStyle),
          flex: 1,
        ),
        Expanded(
          child: Text(d, style: plStyle),
          flex: 1,
        ),
        Expanded(
          child: Text(l, style: plStyle),
          flex: 1,
        ),
        Expanded(
          child: Text(pts, style: plStyle),
          flex: 1,
        )
      ],
    ),
  );
}

final plStyle =
    TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600);

class teamStanding {
  int pos;
  Map<String, dynamic> teamInfo;
  int playedGames;
  int w;
  int d;
  int l;
  int pts;

  teamStanding(this.pos, this.teamInfo, this.playedGames, this.w, this.d,
      this.l, this.pts);
}

Future<List<teamStanding>> getLeagueStandings(String leagueCode) async {
  Response r = await get(
      Uri.encodeFull(
          'https://api.football-data.org/v2/competitions/$leagueCode/standings?standingType=TOTAL'),
      headers: {"X-Auth-Token": token});
  Map<String, dynamic> x = jsonDecode(r.body);
  List y = x['standings'];

  List<teamStanding> k = [];
  for (var i in y[0]['table']) {
    k.add(new teamStanding(i['position'], i['team'], i['playedGames'], i['won'],
        i['draw'], i['lost'], i['points']));
  }

  return k;
}
