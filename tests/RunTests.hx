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
  
  function testCommaSeparatedArray() {
    function string(s:String):tink.stringly.CommaSeparatedArray<String>
      return (s : Stringly);
    function int(s:String):tink.stringly.CommaSeparatedArray<Int>
      return (s : Stringly);
    function float(s:String):tink.stringly.CommaSeparatedArray<Float>
      return (s : Stringly);
    function bool(s:String):tink.stringly.CommaSeparatedArray<Bool>
      return (s : Stringly);
    
    var v = string('a,b,c,d,e');
    for(i in 0...v.length) assertEquals(97 + i, v[i].charCodeAt(0));
    
    var v = int('1,2,3,4,5');
    for(i in 0...v.length) assertEquals(i + 1, v[i]);
    
    var v = float('1.1,2.2,3.3,4.4,5.5');
    for(i in 0...v.length) assertEquals((i + 1) + (i + 1) / 10, v[i]);
    
    var v = bool('true,yes,1,2,whatever');
    for(i in 0...v.length) assertTrue(v[i]);
    
    var v = bool('false,no,0');
    for(i in 0...v.length) assertFalse(v[i]);
  }
  
  static function main() {
    var runner = new TestRunner();
    runner.add(new RunTests());
    travix.Logger.exit(if (runner.run()) 0 else 500);
  }
  
}