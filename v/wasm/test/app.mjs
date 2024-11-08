function get_string(ptr, len) {
  const buf = new Uint8Array(memory.buffer, ptr, len);
  const str = new TextDecoder("utf8").decode(buf);
  return str;
}

var memory;
const env = {
  __writeln: (ptr, len) => console.log(get_string(ptr, len)),
  __panic_abort: (ptr, len) => {
    throw get_string(ptr, len);
  },

  // FUNCTIONS
  get_width: () => document.body.offsetWidth,
  get_height: () => document.body.offsetHeight,
};

WebAssembly.instantiateStreaming(fetch("../build/module.wasm"), {
  env: env,
}).then((res) => {
  memory = res.instance.exports["memory"];

  res.instance.exports["main"]();

  console.log("1 + 2 :", res.instance.exports["add"](1, 2));

  console.log("min(width, height) :", res.instance.exports["min"]());
});
