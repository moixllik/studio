fn JS.get_width() int
fn JS.get_height() int

@[export: 'main']
pub fn main() {
  println('Hello World!')

  //panic('Error!')
}

@[export: 'add']
pub fn add(a int, b int) int {
  return a + b
}

@[export: 'min']
pub fn min_view() int {
  w := JS.get_width()
  h := JS.get_height()
  return if w < h { w } else { h }
}
