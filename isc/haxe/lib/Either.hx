package lib;

enum Either<A, B> {
	Left(l: A);
	Right(r: B);
}
class Eithers {
	public static function either<A, B, R>(e: Either<A, B>, f: A -> R, g: B -> R): R {
		return switch (e) {
			case Left(l): f(l);
			case Right(r): g(r);
		};
	}
	public static function map<A, B, R>(e: Either<A, B>, f: B -> R): Either<A, R> {
		return switch (e) {
			case Left(l): Left(l);
			case Right(r): Right(f(r));
		};
	}
	public static function join<A, B>(o: Either<A, Either<A, B>>): Either<A, B> {
		return switch (o) {
			case Left(l): Left(l);
			case Right(r): r;
		};
	}
	public static function isLeft<A, B>(e: Either<A, B>): Bool {
		return switch (e) {
			case Left(_): true;
			case Right(_): false;
		};
	}
	public static function isRight<A, B>(e: Either<A, B>): Bool {
		return switch (e) {
			case Left(_): false;
			case Right(_): true;
		};
	}
}
