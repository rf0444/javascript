package lib;

extern class Bacon {
	public function combineAsArray<T>(xs: Array<EventStream<T>>): EventStream<Array<T>>;
	@:overload(function<A, B, C, D>(f: A -> B -> C -> D, x: EventStream<A>, y: EventStream<B>, z: EventStream<C>): EventStream<D>{})
	@:overload(function<A, B, C, D, E>(f: A -> B -> C -> D -> E, x: EventStream<A>, y: EventStream<B>, z: EventStream<C>, w: EventStream<D>): EventStream<E>{})
	public function combineWith<A, B, C>(f: A -> B -> C, x: EventStream<A>, y: EventStream<B>): EventStream<C>;
	public function constant<T>(x: T): Property<T>;
	public function mergeAll<T>(xs: Array<EventStream<T>>): EventStream<T>;
	public function never<T>(): EventStream<T>;
	public function once<T>(x: T): EventStream<T>;
	public function zipAsArray<T>(xs: Array<EventStream<T>>): EventStream<Array<T>>;
	@:overload(function<A, B, C, D>(f: A -> B -> C -> D, x: EventStream<A>, y: EventStream<B>, z: EventStream<C>): EventStream<D>{})
	@:overload(function<A, B, C, D, E>(f: A -> B -> C -> D -> E, x: EventStream<A>, y: EventStream<B>, z: EventStream<C>, w: EventStream<D>): EventStream<E>{})
	public function zipWith<A, B, C>(f: A -> B -> C, x: EventStream<A>, y: EventStream<B>): EventStream<C>;
}
extern class EventStream<T> {
	public function assign<R>(f: T -> R): Void -> Void;
	@:overload(function(s: String): EventStream<T>{})
	public function doAction<R>(f: T -> R): EventStream<T>;
	public function filter(f: T -> Bool): EventStream<T>;
	public function flatMap<R>(f: T -> EventStream<R>): EventStream<R>;
	public function flatMapFirst<R>(f: T -> EventStream<R>): EventStream<R>;
	public function flatMapLatest<R>(f: T -> EventStream<R>): EventStream<R>;
	public function log(): EventStream<T>;
	public function map<R>(f: T -> R): EventStream<R>;
	public function mapError<E>(f: E -> T): EventStream<T>;
	public function merge(x: EventStream<T>): EventStream<T>;
	public function scan<R>(x: R, f: R -> T -> R): Property<R>;
	public function take(n: Int): EventStream<T>;
	@:overload(function(): Property<T>{})
	public function toProperty(x: T): Property<T>;
}
extern class Property<T> {
	public function assign<R>(f: T -> R): Void -> Void;
	public function changes(): EventStream<T>;
	public function filter(f: T -> Bool): Property<T>;
	public function log(): Property<T>;
	public function map<R>(f: T -> R): Property<R>;
	public function sampledBy<R>(s: EventStream<R>): EventStream<T>;
}
extern class Bus<T> extends EventStream<T> {
	public function end(): Void;
	public function plug(x: EventStream<T>): Void -> Void;
	public function push(x: T): Void;
}
class Bacons {
	public static function bus<T>(bacon: Bacon): Bus<T> {
		return untyped __js__("new bacon.Bus()");
	}
}
