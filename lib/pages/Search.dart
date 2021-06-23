import 'package:elemental/Components/Data.dart';
import 'package:elemental/Components/elementno.dart';
import 'package:elemental/pages/Element.dart';
import 'package:elemental/pages/Table.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

bool show = false;
bool showbutton = false;
bool found = false;
TextEditingController _filter = new TextEditingController();

class _SearchPageState extends State<SearchPage> {
  List names = [];
  List filteredNames;
  List res = [];
  @override
  void initState() {
    setState(() {
      _filter.clear();
      show = false;
      found = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(16, 16, 16, 1),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 80, left: 20, right: 30),
                  child: TextField(
                    onChanged: (_filter) {
                      if (_filter.length == 0) {
                        setState(() {
                          showbutton = false;
                          _filter = '';
                        });
                      } else {
                        setState(() {
                          showbutton = true;
                          _getNames(_filter.toLowerCase());
                        });
                      }
                    },
                    controller: _filter,
                    style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black45),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Search element ..',
                      hintStyle: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54,
                      ),
                      suffixIcon: showbutton == false
                          ? Icon(Icons.search)
                          : IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  _filter.clear();
                                  showbutton = false;
                                  show = false;
                                  found = false;
                                });
                              },
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.4,
                child: showscreen(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _getNames(String name) async {
    int check = 0;
    if (name.length == 0) {
      setState(() {
        show = false;
      });
    } else {
      Period period = new Period();
      var data = period.period;
      setState(() {
        res = [];
        for (int i = 0; i < 118; i++) {
          var temp = data[i]['name'].toString();
          names.add(temp);
        }
      });
      for (int i = 0; i < 118; i++) {
        String ele = '';
        ele = names[i];
        ele = ele.toLowerCase();

        if (ele.contains(name)) {
          setState(() {
            res.add(ele);
            check = 1;
          });
        }
      }
      if (check == 1) {
        setState(() {
          show = true;
          found = true;
        });
      } else {
        setState(() {
          found = false;
        });
      }
    }
  }

  Widget showscreen() {
    Widget out;
    if (show == true && found == true) {
      out = _buildlist();
    } else if (show == false && found == false) {
      out = Search_something();
    } else {
      out = Notfound();
    }
    return out;
  }

  Widget _buildlist() {
    int atnum;
    elementno elno = elementno();
    var n = elno.element;
    return ListView.builder(
      key: UniqueKey(),
      itemCount: res.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                atnum = int.parse(n[res[index].substring(0, 1).toUpperCase() +
                    res[index].substring(1)]);
                atnum -= 1;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ElementPage(
                      atomicnum: atnum,
                    ),
                  ),
                );
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            res[index].substring(0, 1).toUpperCase() +
                                res[index].substring(1),
                            style: GoogleFonts.nunito(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Tap to know more',
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(child: Lottie.asset('assets/atom.json')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Search_something extends StatelessWidget {
  const Search_something({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 300,
            height: 300,
            child: Lottie.asset('assets/search.json'),
          ),
          Text(
            'Search something...',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}

class Notfound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: Lottie.asset('assets/notfound.json'),
          ),
          Text(
            'Not Found',
            style: GoogleFonts.nunito(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}
