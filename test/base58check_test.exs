defmodule Base58CheckTest do
  use ExUnit.Case

  import Base58Check

  test "encode58/1" do
    assert encode58(0) == ""
    assert encode58(57) == "z"
    assert encode58(1024) == "Jf"
    assert encode58(123_456_789) == "BukQL"
    assert encode58(<<1, 0>>) == "5R"
  end

  test "decode58/1" do
    assert decode58("") == 0
    assert decode58("z") == 57
    assert decode58("Jf") == 1024
    assert decode58("BukQL") == 123_456_789
  end

  @test_hex "1e99423a4ed27608a15a2616a2b0e9e52ced330ac530edcc32c8ffc6a526aedd"
  @test_base58 "5J3mBbAH58CpQ3Y5RNJpUKPE62SQ5tfcvU2JpbnkeyhfsYB1Jcn"

  test "encode58check/2 accepts integer" do
    bin = Base.decode16!(@test_hex, case: :lower)
    integer = :binary.decode_unsigned(bin)
    assert encode58check(128, integer) == @test_base58
  end

  test "encode58check/2 accepts binary" do
    data_bin = Base.decode16!(@test_hex, case: :lower)
    prefix_bin = :binary.encode_unsigned(128)
    assert encode58check(prefix_bin, data_bin) == @test_base58
  end

  test "encode58check/2 accepts hex" do
    assert encode58check(128, @test_hex) == @test_base58
    btc_address = "1EUbuiBzfdq939oPArvPGe6sRcUskoYCexXbRk1R6r2hwNdAP2"
    assert encode58check(0, @test_hex) == btc_address
  end

  test "decode58check/1 accepts hex and returns prefix and payload" do
    {prefix, payload} = decode58check(@test_base58, 32)
    assert Base.encode16(payload, case: :lower) == @test_hex
    assert :binary.decode_unsigned(prefix) == 128
  end

  test "decode58check/1 raises if address too long" do
    assert_raise ArgumentError, fn ->
      decode58check(@test_base58)
    end
  end

  test "decode58check/1 raises if address too short" do
    assert_raise ArgumentError, fn ->
      decode58check("1e")
    end
  end

  test "decode58check/1 raises when checksum doesn't match" do
    assert_raise ArgumentError, fn ->
      decode58check("5J3mBbAH58CpQ3Y5RNJpUKPE62SQ5tfcvU2JpbnkeyhfsYB1Jc")
    end
  end

  test "decode58check/1 does not raise for valid address 1" do
    decode58check("1111111111111111111114oLvT2")
  end

  test "decode58check/1 does not raise for valid address 2" do
    decode58check("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i")
  end

  test "decode58check/1 does not raise for valid address 3" do
    decode58check("3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy")
  end

  test "decode58check/1 raises on invalid chars in address" do
    assert_raise ArgumentError, fn ->
      decode58check("0J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy")
    end
  end

  test "decode58check/1 raises on address with leading `1` dropped" do
    assert {<<0>>,
            <<11, 169, 175, 6, 251, 40, 253, 242, 64, 156, 131, 45, 88, 90, 235, 125, 185, 138,
              133, 38>>} == decode58check("124fhwYEZQKS5P7YZJHUNZPYa8goeTf7JX")

    assert_raise ArgumentError, fn ->
      decode58check("24fhwYEZQKS5P7YZJHUNZPYa8goeTf7JX")
    end
  end
end
