# Tinkerbell ~~Stringly Mess~~ Stringliness

[![Build Status](https://travis-ci.org/haxetink/tink_stringly.svg?branch=master)](https://travis-ci.org/haxetink/tink_stringly)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/haxetink/public)

A harsh and inescapable truth of contemporary programming reality is that there's a lot of stringliness going on everywhere. Numeric values just get passed around as their string representation and you somehow have to deal with it. Be it command line parameters, query string parameters or XML / HTML attributes. 

Some dynamically typed languages (most notably JavaScript) solve this by trying to make sense of numerical operations on strings at runtime. This becomes particularly delightful if the operation is `+` and one of the operands suddenly happens to be a string. Let's learn from that design flaw!

This library proposes tackling the issue by use of the following type:
  
```haxe
abstract Stringly(String) from String to String {
  
  @:to public function toBool():Bool;
  @:to public function parseFloat():Outcome<Float, Error>;  
  @:to function toFloat():Float;
  @:to public function parseInt():Outcome<Int, Error>;
  @:to function toInt():Int;
  @:to public function parseDate():Outcome<Date, Error>;
  @:to function toDate():Date;
      
  @:from static function ofBool(b:Bool):Stringly;
  @:from static function ofInt(i:Int):Stringly;
  @:from static function ofFloat(f:Float):Stringly;
  @:from static function ofDate(d:Date):Stringly;
}  
```

It is worth noting that parsing numbers is stricter than `Std.parseInt` or `Std.parseFloat` in that it requires the whole string to be part of the number. The implicit `toFloat` and `toInt` throw exceptions. Since the exception is raised when the value is converted instead of when it is operated on, it is slightly easier to pinpoint the cause of errors.

