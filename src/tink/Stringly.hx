package tink;

using tink.CoreApi;
using StringTools;

abstract Stringly(String) from String to String {
   
  static function isNumber(s:String, allowFloat:Bool) {
    
    if (s.length == 0) return false;
    
    var pos = 0,
        max = s.length;
        
    inline function isDigit(code)
      return code ^ 0x30 < 10;//a sharp glimpse at the ASCII table revealed this to me
        
    inline function digits()
      while (pos < max && isDigit(s.fastCodeAt(pos))) pos++;
    
    inline function allow(code)
      return 
        if (pos < max && s.fastCodeAt(pos) == code) pos++ > -1;//always true ... not pretty, but generates much simpler code ... check with 3.3 again to see if it can be removed
        else false;
    
    allow('-'.code);
    
    if (!allowFloat) {
      if (allow('0'.code))
        allow('x'.code);
    }
    
    digits();
    
    if (allowFloat && pos < max) {
      if (allow('.'.code))
        digits();
        
      if (allow('e'.code) || allow('E'.code)) {
        allow('+'.code) || allow('-'.code);
        digits();
      }
    }
    
    return pos == max;
  }
    
  @:to public function toBool()
    return 
      this != null && switch this.trim().toLowerCase() {
        case 'false', '0', 'no': false;
        default: true;
      }
    
  @:to public function parseFloat()
    return switch this.trim() {
      case v if (isNumber(v, true)):
        Success((Std.parseFloat(v) : Float));
      case v:
        Failure(new Error(UnprocessableEntity, '$v (encoded as $this) is not a valid float'));
    }
  
  @:to function toFloat()
    return parseFloat().sure();
    
  @:to public function parseInt()
    return switch this.trim() {
      case v if (isNumber(v, false)):
        Success((Std.parseInt(v) : Int));
      case v:
        Failure(new Error(UnprocessableEntity, '$v (encoded as $this) is not a valid integer'));
    }
        
  @:to function toInt()
    return parseInt().sure();
    
  @:to public function parseDate() {
    inline function fail() {
      return Failure(new Error(UnprocessableEntity, '$this is not a valid date'));
    }
    return switch parseFloat() {
      case Success(f): Success(Date.fromTime(f));
      case Failure(_): 
      #if js
        var date:Date = untyped __js__('new Date({0})', this);
        if(Math.isNaN(date.getTime())) fail() else Success(date);
      #else
        throw 'not implemented';
      #end
    }
  }
  
  @:to function toDate()
    return parseDate().sure();
      
  @:from static inline function ofBool(b:Bool):Stringly
    return if (b) 'true' else 'false';
    
  @:from static inline function ofInt(i:Int):Stringly
    return Std.string(i);  
    
  @:from static inline function ofFloat(f:Float):Stringly
    return Std.string(f);    
    
  @:from static inline function ofDate(d:Date):Stringly
    return Std.string(d.getTime());    
}