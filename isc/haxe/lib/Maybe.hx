package lib;

enum Maybe<T> {
	Nothing;
	Just(x: T);
}
class Maybes {
	public static function wrap<T>(x: Null<T>): Maybe<T> {
		return if (x == null) Nothing else Just(x);
	}
	public static function maybe<T, R>(m: Maybe<T>, x: R, f: T -> R): R {
		return switch (m) {
			case Nothing: x;
			case Just(y): f(y);
		};
	}
	public static function map<T, R>(m: Maybe<T>, f: T -> R): Maybe<R> {
		return switch (m) {
			case Nothing: Nothing;
			case Just(x): Just(f(x));
		};
	}
	public static function filter<T>(m: Maybe<T>, f: T -> Bool): Maybe<T> {
		return switch (m) {
			case Nothing: Nothing;
			case Just(x): if (f(x)) Just(x) else Nothing;
		};
	}
	public static function join<T>(m: Maybe<Maybe<T>>): Maybe<T> {
		return switch (m) {
			case Nothing: Nothing;
			case Just(x): x;
		};
	}
	public static function or<T>(m: Maybe<T>, def: T): T {
		return switch (m) {
			case Nothing: def;
			case Just(x): x;
		};
	}
}
