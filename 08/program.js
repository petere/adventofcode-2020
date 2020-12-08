#!/usr/bin/env node

/*jshint esversion: 6 */

const fs = require('fs');

var instrs = [];

var lines = fs.readFileSync('input.txt').toString().split("\n");

for (const line of lines) {
  if (line === '')
    continue;
  let s = line.split(" ");
  let x = {"op": s[0], "arg": parseInt(s[1])};
  instrs.push(x);
}

function run(instrs)
{
  var beenthere = [];

  var ip = 0;
  var acc = 0;

  while (ip < instrs.length && !beenthere.includes(ip)) {
    let op = instrs[ip].op;
    let arg = instrs[ip].arg;

    beenthere.push(ip);

    switch (op) {
    case "acc":
      acc += arg;
      ip++;
      break;
    case "jmp":
      ip += arg;
      break;
    case "nop":
      ip++;
      break;
    }
  }

  return { "finished": ip == instrs.length, "acc": acc };
}

console.log(run(instrs).acc);

// part 2

for (const i in instrs) {
  const instr = instrs[i];

  let newop;
  switch (instr.op) {
  case "jmp":
    newop = "nop";
    break;
  case "nop":
    newop = "jmp";
    break;
  default:
    continue;
  }

  let new_instrs = instrs.slice(); // copy array
  new_instrs[i] = {"op": newop, "arg": instr.arg};

  let result = run(new_instrs);
  if (result.finished) {
    console.log(result.acc);
    break;
  }
}
