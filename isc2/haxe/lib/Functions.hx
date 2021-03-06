package lib;

class Functions {
	public static function andThen<A, B, C>(f: A -> B, g: B -> C): A -> C {
		return function(x) { return g(f(x)); };
	}
	public static function id<A>(x: A): A { return x; }
	public static function ignore<A>(x: A): Void {}
	public static function constant<A, B>(x: A): B -> A {
		return function(_) { return x; };
	}
	public static function isNull<A>(x: A): Bool { return x == null; }
	public static function notNull<A>(x: A): Bool { return x != null; }
	public static function not<A>(x: Bool): Bool { return !x; }
	public static function iterable<A>(itr: Iterator<A>): Iterable<A> {
		return { iterator: function() { return itr; } };
	}
	public static function fix<A, B>(f: (A -> B) -> (A -> B)): A -> B {
		return function(x) { return f(fix(f))(x); };
	}
}
