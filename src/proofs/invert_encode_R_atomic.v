Require Import Coq.ZArith.BinInt.
Require Import riscv.encode.Encode.
Require Import riscv.util.ZBitOps.
Require Import riscv.proofs.prove_Zeq_bitwise.

Lemma invert_encode_R_atomic: forall {opcode rd rs1 rs2 funct3 aqrl funct5},
  verify_R_atomic opcode rd rs1 rs2 funct3 aqrl funct5 ->
  forall inst,
  encode_R_atomic opcode rd rs1 rs2 funct3 aqrl funct5 = inst ->
  opcode = bitSlice inst 0 7 /\
  funct3 = bitSlice inst 12 15 /\
  aqrl = bitSlice inst 25 27 /\
  funct5 = bitSlice inst 27 32 /\
  rd = bitSlice inst 7 12 /\
  rs1 = bitSlice inst 15 20 /\
  rs2 = bitSlice inst 20 25.
Proof. intros. unfold encode_R_atomic, verify_R_atomic in *. prove_Zeq_bitwise. Qed.
