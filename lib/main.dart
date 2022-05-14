import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_size/window_size.dart';
import 'AdvDiv.dart';

void main() {
	WidgetsFlutterBinding.ensureInitialized();
	if(Platform.isWindows || Platform.isLinux) {
		setWindowTitle("Advanced Division");
		setWindowMinSize(const Size(500, 800));
		setWindowMaxSize(Size.infinite);
	};
	runApp(const MyApp());
}

String filtern1(String text) {
	if(text.length > 1 && text.indexOf("\u0305")==text.length - 2)
		text = text.replaceFirst(RegExp(r'\u0305(r|\u0305)$'), "");
	if(text.indexOf("r") > -1)
		text = (text.split("r")[0].replaceAll("\u0305", ""))+"\u0305"+((text.split("r")..removeAt(0)).join(""));
	text = text.replaceAll(",", ".").replaceAll(RegExp(r'[^\d\.\u0305]'), "").replaceFirst(RegExp(r'^0+'), "").replaceFirst(RegExp(r'^\.'), "0.").replaceFirst(RegExp(r'^$'), "0");
	if(text.indexOf(".") < 0)
		return text.replaceAll("\u0305", "");
	text = (text.split(".")[0].replaceAll("\u0305", ""))+"."+((text.split(".")..removeAt(0)).join(""));
	if(text.indexOf("\u0305") < 0)
		return text;
	return ((text.split("\u0305")[0])+"\u0305"+((text.split("\u0305")..removeAt(0)).join("").split("").join("\u0305"))+"\u0305").replaceAll("\u0305\u0305", "\u0305").replaceFirst(".\u0305", ".");
}

String filtern2(String text) {
	text = text.replaceAll(",", ".").replaceAll(RegExp(r'[^\d\.]'), "").replaceFirst(RegExp(r'^0+'), "").replaceFirst(RegExp(r'^\.'), "0.").replaceFirst(RegExp(r'^$'), "0");
	if(text.indexOf(".") < 0)
		return text;
	return (text.split(".")[0])+"."+((text.split(".")..removeAt(0)).join(""));
}

String calculate(final String n1s, final String n2s) {
	late final int r;
	late final double n1, n2;
	late final String result;
	late final String? res;
	n2 = double.parse(n2s);
	if(n1s.contains("\u0305")) {
		n1 = double.parse(n1s.substring(0, n1s.indexOf("\u0305") - 1).replaceFirst(r'.$', ""));
		r = int.parse(n1s.substring(n1s.indexOf("\u0305") - 1).replaceAll("\u0305", ""));
	}
	else {
		n1 = double.parse(n1s);
		r = 0;
	};
	res = advdiv(n1, n2, r);
	if(res is String)
		result = res;
	else
		result = "Error";
	if(!result.contains("["))
		return result;
	return (result.split("[")[0])+(result.split("[")[1].replaceFirst("]", "").split("").join("\u0305"))+"\u0305";
}


class MyApp extends StatelessWidget {
	const MyApp({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: "Advanced Division",
			theme: ThemeData(
				brightness: Brightness.dark,
				primarySwatch: const MaterialColor(0xff714cfe, { 50: const Color(0xffeee6ff), 100: Color(0xffd2c2fd), 200: Color(0xffb39afd), 300: Color(0xff916eff), 400: Color(0xff714cfe), 500: Color(0xff4a26fd), 600: Color(0xff3722f6), 700: Color(0xff021aee), 800: Color(0xff0013e9), 900: Color(0x0000e4) })
			),
			home: const MyHomePage(title: "Advanced Division")
		);
	}
}

class MyHomePage extends StatefulWidget {
	const MyHomePage({ Key? key, required this.title }) : super(key: key);

	final String title;

	@override
	State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

	bool fn2 = false;
	String n1 = "0", n2 = "1";
	TextEditingController n1field = TextEditingController(), n2field = TextEditingController(), resfield = TextEditingController();
	ScrollController resScrollController = ScrollController();
	FocusNode focus1 = new FocusNode(), focus2 = new FocusNode();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Container(
				alignment: Alignment.center,
				padding: const EdgeInsets.fromLTRB(40, 60, 40, 0),
				child: Column(
					children: <Widget>[
						FocusScope(
							child: FocusTraversalGroup(
								policy: OrderedTraversalPolicy(),
								child: Row(
									mainAxisAlignment: MainAxisAlignment.center,
									children: <Widget>[
										FocusTraversalOrder(
											order: NumericFocusOrder(0),
											child: Focus(
												child: Text(""),
												onFocusChange: (focus) {
													if(focus) {
														fn2 = true;
														FocusScope.of(context).requestFocus(focus2);
													};
												}
											)
										),
										Flexible(
											child: Focus(
												autofocus: true,
												child: FocusTraversalOrder(
													order: NumericFocusOrder(1),
													child: TextField(
														controller: n1field,
														focusNode: focus1,
														autocorrect: false,
														style: GoogleFonts.andika(
															fontSize: 24
														),
														onChanged: (text) {
															int caretfromend;
															if(text==n1)
																return;
															caretfromend = text.length - n1field.selection.end;
															n1 = filtern1(text);
															if(text.indexOf("=") > -1) {
																resfield.text = calculate(n1, n2);
																n1field.text = n1;
																return;
															};
															if(text.indexOf("/") > -1 || text.indexOf("∶") > -1)
																fn2 = true;
															n1field.text = n1;
															if(fn2) {
																FocusScope.of(context).requestFocus(focus2);
																return;
															};
															FocusScope.of(context).requestFocus(focus1);
															n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
														},
														onSubmitted: (text) {
															resfield.text = calculate(n1, n2);
														}
													)
												),
												onFocusChange: (focus) {
													if(n1field.text=="")
														n1field.text = n1;
													if(n2field.text=="")
														n2field.text = n2;
													if(focus)
														fn2 = false;
												}
											)
										),
										Container(
											margin: const EdgeInsets.symmetric(horizontal: 40),
											alignment: Alignment.center,
											child: const Text(
												"∶",
												style: TextStyle(
													fontSize: 24
												)
											)
										),
										Flexible(
											child: Focus(
												child: FocusTraversalOrder(
													order: NumericFocusOrder(2),
													child: TextField(
														controller: n2field,
														focusNode: focus2,
														autocorrect: false,
														style: GoogleFonts.andika(
															fontSize: 24
														),
														onChanged: (text) {
															int caretfromend;
															if(text==n2)
																return;
															caretfromend = text.length - n2field.selection.end;
															n2 = filtern2(text);
															if(text.indexOf("=") > -1) {
																resfield.text = calculate(n1, n2);
																n2field.text = n2;
																return;
															};
															if(text.indexOf("/") > -1 || text.indexOf("∶") > -1)
																fn2 = false;
															n2field.text = n2;
															if(!fn2) {
																FocusScope.of(context).requestFocus(focus1);
																return;
															};
															FocusScope.of(context).requestFocus(focus2);
															n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
														},
														onSubmitted: (text) {
															resfield.text = calculate(n1, n2);
														}
													)
												),
												onFocusChange: (focus) {
													if(n1field.text=="")
														n1field.text = n1;
													if(n2field.text=="")
														n2field.text = n2;
													if(focus)
														fn2 = true;
												}
											)
										),
										FocusTraversalOrder(
											order: NumericFocusOrder(3),
											child: Focus(
												child: Text(""),
												onFocusChange: (focus) {
													if(focus) {
														fn2 = false;
														FocusScope.of(context).requestFocus(focus1);
													};
												}
											)
									 ),
										Container(
											margin: const EdgeInsets.only(left: 40),
											child: ExcludeFocus(
												excluding: true,
												child: ElevatedButton(
													style: ElevatedButton.styleFrom(
														minimumSize: const Size(60, 60),
														maximumSize: const Size(60, 60)
													),
													onPressed: () {
														resfield.text = calculate(n1, n2);
													},
													child: const Text("=")
												)
											)
										)
									]
								)
							)
						),
						Container(
							margin: const EdgeInsets.symmetric(vertical: 40),
							child: Scrollbar(
								controller: resScrollController,
								child: TextField(
									controller: resfield,
									scrollController: resScrollController,
									readOnly: true,
									decoration: null,
									style: GoogleFonts.andika(
										fontSize: 24
									)
								)
							)
						),
						Container(
							alignment: Alignment.center,
							margin: const EdgeInsets.symmetric(vertical: 20),
							width: 360,
							height: 480,
							child: GridView.count(
								primary: false,
								crossAxisSpacing: 40,
								mainAxisSpacing: 40,
								crossAxisCount: 4,
								childAspectRatio: 1,
								children: <Widget>[
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											int caretfromend;
											if(fn2) {
												caretfromend = n2field.text.length - n2field.selection.end;
												n2 = filtern2(n2field.text.substring(0, n2field.selection.start)+"1"+n2field.text.substring(n2field.selection.end));
												n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
											}
											else {
												caretfromend = n1field.text.length - n1field.selection.end;
												n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+"1"+n1field.text.substring(n1field.selection.end));
												n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
											};
										},
										child: const Text("1")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											int caretfromend;
											if(fn2) {
												caretfromend = n2field.text.length - n2field.selection.end;
												n2 = filtern2(n2field.text.substring(0, n2field.selection.start)+"2"+n2field.text.substring(n2field.selection.end));
												n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
											}
											else {
												caretfromend = n1field.text.length - n1field.selection.end;
												n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+"2"+n1field.text.substring(n1field.selection.end));
												n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
											};
										},
										child: const Text("2")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											int caretfromend;
											if(fn2) {
												caretfromend = n2field.text.length - n2field.selection.end;
												n2 = filtern2(n2field.text.substring(0, n2field.selection.start)+"3"+n2field.text.substring(n2field.selection.end));
												n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
											}
											else {
												caretfromend = n1field.text.length - n1field.selection.end;
												n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+"3"+n1field.text.substring(n1field.selection.end));
												n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
											};
										},
										child: const Text("3")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											int caretfromend;
											if(fn2) {
												caretfromend = n2field.text.length - n2field.selection.end;
												if(n2field.selection.start!=n2field.selection.end) {
													n2 = filtern2(n2field.text.substring(0, n2field.selection.start)+n2field.text.substring(n2field.selection.end));
													n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
													n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
												}
												else if(n2field.selection.start > 0) {
													n2 = filtern2(n2field.text.substring(0, n2field.selection.start - 1)+n2field.text.substring(n2field.selection.end));
													n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
													n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
												};
											}
											else {
												caretfromend = n1field.text.length - n1field.selection.end;
												if(n1field.selection.start!=n1field.selection.end) {
													n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+n1field.text.substring(n1field.selection.end));
													n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
													n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
												}
												else if(n2field.selection.end > 0) {
													n1 = filtern1(n1field.text.substring(0, n1field.selection.start - 1)+n1field.text.substring(n1field.selection.end));
													n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
													n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
												};
											};
										},
										child: const Text("⌫")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											int caretfromend;
											if(fn2) {
												caretfromend = n2field.text.length - n2field.selection.end;
												n2 = filtern2(n2field.text.substring(0, n2field.selection.start)+"4"+n2field.text.substring(n2field.selection.end));
												n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
											}
											else {
												caretfromend = n1field.text.length - n1field.selection.end;
												n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+"4"+n1field.text.substring(n1field.selection.end));
												n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
											};
										},
										child: const Text("4")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											int caretfromend;
											if(fn2) {
												caretfromend = n2field.text.length - n2field.selection.end;
												n2 = filtern2(n2field.text.substring(0, n2field.selection.start)+"5"+n2field.text.substring(n2field.selection.end));
												n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
											}
											else {
												caretfromend = n1field.text.length - n1field.selection.end;
												n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+"5"+n1field.text.substring(n1field.selection.end));
												n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
											};
										},
										child: const Text("5")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											int caretfromend;
											if(fn2) {
												caretfromend = n2field.text.length - n2field.selection.end;
												n2 = filtern2(n2field.text.substring(0, n2field.selection.start)+"6"+n2field.text.substring(n2field.selection.end));
												n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
											}
											else {
												caretfromend = n1field.text.length - n1field.selection.end;
												n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+"6"+n1field.text.substring(n1field.selection.end));
												n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
											};
										},
										child: const Text("6")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											int caretfromend;
											if(fn2) {
												caretfromend = n2field.text.length - n2field.selection.end;
												if(n2field.selection.start!=n2field.selection.end) {
													n2 = filtern2(n2field.text.substring(0, n2field.selection.start)+n2field.text.substring(n2field.selection.end));
													n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
													n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
												}
												else if(caretfromend > 0) {
													n2 = filtern2(n2field.text.substring(0, n2field.selection.start)+n2field.text.substring(n2field.selection.end + 1));
													n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
													n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend + 1);
												};
											}
											else {
												caretfromend = n1field.text.length - n1field.selection.end;
												if(n1field.selection.start!=n2field.selection.end) {
													n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+n1field.text.substring(n1field.selection.end));
													n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
													n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
												}
												else if(caretfromend > 0) {
													n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+n1field.text.substring(n1field.selection.end + 1));
													n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
													n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend + 1);
												}
											};
										},
										child: const Text("⌦")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											int caretfromend;
											if(fn2) {
												caretfromend = n2field.text.length - n2field.selection.end;
												n2 = filtern2(n2field.text.substring(0, n2field.selection.start)+"7"+n2field.text.substring(n2field.selection.end));
												n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
											}
											else {
												caretfromend = n1field.text.length - n1field.selection.end;
												n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+"7"+n1field.text.substring(n1field.selection.end));
												n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
											};
										},
										child: const Text("7")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											int caretfromend;
											if(fn2) {
												caretfromend = n2field.text.length - n2field.selection.end;
												n2 = filtern2(n2field.text.substring(0, n2field.selection.start)+"8"+n2field.text.substring(n2field.selection.end));
												n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
											}
											else {
												caretfromend = n1field.text.length - n1field.selection.end;
												n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+"8"+n1field.text.substring(n1field.selection.end));
												n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
											};
										},
										child: const Text("8")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											int caretfromend;
											if(fn2) {
												caretfromend = n2field.text.length - n2field.selection.end;
												n2 = filtern2(n2field.text.substring(0, n2field.selection.start)+"9"+n2field.text.substring(n2field.selection.end));
												n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
											}
											else {
												caretfromend = n1field.text.length - n1field.selection.end;
												n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+"9"+n1field.text.substring(n1field.selection.end));
												n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
											};
										},
										child: const Text("9")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											if(fn2) {
												n2 = "";
												n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: 0);
											}
											else {
												n1 = "";
												n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: 0);
											};
										},
										child: const Text("⌧")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											int caretfromend;
											if(fn2) {
												caretfromend = n2field.text.length - n2field.selection.end;
												n2 = filtern2(n2field.text.substring(0, n2field.selection.start)+"."+n2field.text.substring(n2field.selection.end));
												n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
											}
											else {
												caretfromend = n1field.text.length - n1field.selection.end;
												n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+"."+n1field.text.substring(n1field.selection.end));
												n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
											};
										},
										child: const Text(".")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											int caretfromend;
											if(fn2) {
												caretfromend = n2field.text.length - n2field.selection.end;
												n2 = filtern2(n2field.text.substring(0, n2field.selection.start)+"0"+n2field.text.substring(n2field.selection.end));
												n2field.text = n2;
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: n2.length - caretfromend);
											}
											else {
												caretfromend = n1field.text.length - n1field.selection.end;
												n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+"0"+n1field.text.substring(n1field.selection.end));
												n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
											};
										},
										child: const Text("0")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											int caretfromend;
											if(fn2) {
												FocusScope.of(context).requestFocus(focus2);
											}
											else {
												caretfromend = n1field.text.length - n1field.selection.end;
												n1 = filtern1(n1field.text.substring(0, n1field.selection.start)+"\u0305"+n1field.text.substring(n1field.selection.end));
												n1field.text = n1;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1.length - caretfromend);
											};
										},
										child: const Text("\u0305")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											if(fn2) {
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: 0);
											}
											else {
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: 0);
											};
										},
										child: const Text("\u21a4")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											if(fn2) {
												if(n2field.selection.end < 1)
													return;
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: n2field.selection.end - 1);
											}
											else {
												if(n1field.selection.end < 1)
													return;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1field.selection.end - 1);
											};
										},
										child: const Text("←")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											if(fn2) {
												if(n2field.selection.end >= n2field.text.length)
													return;
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: n2field.selection.end + 1);
											}
											else {
												if(n1field.selection.end >= n1field.text.length)
													return;
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1field.selection.end + 1);
											};
										},
										child: const Text("→")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											if(fn2)
												FocusScope.of(context).requestFocus(focus1);
											else
												FocusScope.of(context).requestFocus(focus2);
										},
										child: const Text("∶")
									),
									OutlinedButton(
										style: OutlinedButton.styleFrom(
											minimumSize: const Size(40, 40),
											maximumSize: const Size(60, 60)
										),
										onPressed: () {
											if(fn2) {
												FocusScope.of(context).requestFocus(focus2);
												n2field.selection = TextSelection.collapsed(offset: n2.length);
											}
											else {
												FocusScope.of(context).requestFocus(focus1);
												n1field.selection = TextSelection.collapsed(offset: n1.length);
											};
										},
										child: const Text("\u21a6")
									)
								]
							)
						)
					]
				)
			)
		);
	}
}