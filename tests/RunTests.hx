package ;

import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import tink.Stringly;

using tink.CoreApi;

class RunTests extends TestCase {
  
  function testStringify() {
    inline function eq(a:String, b:Stringly, ?pos) {
      assertEquals(a, b, pos);
    }
    
    eq('100', 100);
    eq('123.456', 123.456);
    eq('true', true);
    #if js
    eq('1483232461000', utc(2017,0,1,1,1,1));
    #end
    eq('just some string', 'just some string');
  }
  
  function testParseInt() {
    
    inline function invalidInt(val:Stringly, ?pos) 
      assertFalse(val.parseInt().isSuccess(), pos);
    
    invalidInt('10g');
    invalidInt('10.34');
    
    inline function eq(a:Int, b:Stringly, ?pos) 
      assertEquals(a, b, pos);
      
    for (i in 0...50) {
      var v = Std.random(100000000);
      eq(v,   v );
      eq(v, '$v');  
    }
  }
  

  function testParseFloat() {
    
    inline function invalidFloat(val:Stringly, ?pos) 
      assertFalse(val.parseFloat().isSuccess(), pos);
    
    invalidFloat('10g');
    invalidFloat('10.34.5');
    
    inline function eq(a:Float, b:Stringly, ?pos) 
      assertEquals(a, b, pos);
      
    for (i in 0...50) {
      var v = Std.parseFloat(Std.string(i * Math.random() / Math.random()));
      eq(v,   v );
      eq(v, '$v');  
    }
  }  
  
  #if js
  function testParseDate() {
    
    inline function invalidDate(val:Stringly, ?pos) 
      assertFalse(val.parseDate().isSuccess(), pos);
    
    invalidDate('a');
    invalidDate('2a');
    
    inline function eq(a:Date, b:Stringly, ?pos) 
      assertEquals(a.getTime(), (b:Date).getTime(), pos);
    
    eq(utc(2017,0,1,1,1,1), '1483232461000');
    eq(utc(2017,0,1,1,1,1), '2017-01-01T01:01:01Z');
    eq(utc(2017,0,1,1,1,1), '2017-01-01T01:01:01+00:00');
    eq(utc(2017,0,1,1,1,1), '2017-01-01T09:01:01+08:00');
    eq(utc(2017,0,1,0,0,0), '2017-01-01');
  }
  #end
  
  function testParseBool() {
    function bool(s:String):Bool
      return (s : Stringly);
      
    assertTrue(bool('true'));
    assertTrue(bool('yes'));
    assertTrue(bool('1'));
    assertTrue(bool('2'));
    assertTrue(bool('whatever'));
    
    assertFalse(bool('false'));
    assertFalse(bool('no'));
    assertFalse(bool('0'));
    assertFalse(bool(null));
  }
  
  function utc(y, m, d, H, M, S)
    return DateTools.delta(new Date(y, m, d, H, M, S), -Date.fromString('1970-01-01 00:00:00').getTime());
  
  static function main() {
    var runner = new TestRunner();
    runner.add(new RunTests());
    travix.Logger.exit(if (runner.run()) 0 else 500);
  }
  
}