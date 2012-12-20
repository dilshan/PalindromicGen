//******************************************************************************
// Simple Palindromic Number Seeker.
//
// Copyright (c) 2012 Dilshan R Jayakody. [jayakody2000lk@gmail.com]
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//******************************************************************************

unit DynamicNumber;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TDynamicNumber = class(TObject)
  private
    CoreNumber : String;
    OverflowFlag : Boolean;
    function GetNumberAtPos(InVal : String; ValPos : longint; MaxPos : longint) : byte;
  public
    constructor Create(InitNum : String); virtual;
    destructor Destroy; override;
    procedure SetNumber(InVal : String);
    function GetNumber() : String;
    procedure AddDynamicNumber(Num2 : TDynamicNumber; out RetNum : TDynamicNumber);
    function FlipNumber() : TDynamicNumber;
    function IsOverflow() : Boolean;
  end;

implementation

constructor TDynamicNumber.Create(InitNum : String);
begin
  if(InitNum = '') then
    InitNum := '0';
  CoreNumber := InitNum;
  OverflowFlag := false;
end;

destructor TDynamicNumber.Destroy;
begin
  CoreNumber := '';
  inherited Destroy;
end;

function TDynamicNumber.GetNumber() : String;
begin
  result := CoreNumber;
end;

function TDynamicNumber.IsOverflow() : Boolean;
begin
  result := OverflowFlag;
end;

procedure TDynamicNumber.SetNumber(InVal : String);
begin
  if(InVal = '') then
    InVal := '0';
  CoreNumber := InVal;
  OverflowFlag := false;
end;

function TDynamicNumber.GetNumberAtPos(InVal : String; ValPos : longint; MaxPos : longint) : byte;
begin
  //Range check to avoid array index overflows / underflows
  if((ValPos > MaxPos) or (ValPos <= 0)) then
    result := 0
  else
    result := Ord(InVal[ValPos]) - 48;
end;

procedure TDynamicNumber.AddDynamicNumber(Num2 : TDynamicNumber; out RetNum : TDynamicNumber);
var
  num1_pos, num2_pos, loop_pos : longint; num_out, carry : byte; out_num : string;
  num1_max, num2_max : longint;
begin
  RetNum.SetNumber('0');
  num1_pos := Length(CoreNumber);
  num2_pos := Length(Num2.GetNumber());
  num1_max := num1_pos;
  num2_max := num2_pos;
  loop_pos := 0;
  out_num := '';
  carry := 0;
  //check for range overflows
  while(loop_pos < MaxInt) do
  begin
    //Loop termination check
    if((num1_pos <= 0) and (num2_pos <= 0) and (carry = 0)) then
    begin
      RetNum.SetNumber(out_num);
      break;
    end;
    num_out := GetNumberAtPos(self.CoreNumber, num1_pos, num1_max) + GetNumberAtPos(Num2.GetNumber(), num2_pos, num2_max) + carry;
    if(num_out > 9) then
    begin
      carry := num_out div 10;
      num_out := num_out mod 10;
    end else
      carry := 0;
    out_num := Chr(num_out + 48) + out_num;
    dec(num1_pos);
    dec(num2_pos);
    inc(loop_pos);
  end;
  OverflowFlag := ((loop_pos + 1) >= MaxInt);
end;

function TDynamicNumber.FlipNumber() : TDynamicNumber;
var
  num_pos : longint; flip_num : string;
begin
  flip_num := '';
  num_pos := Length(self.CoreNumber);
  while(num_pos > 0) do
  begin
    flip_num := flip_num + self.CoreNumber[num_pos];
    dec(num_pos);
  end;
  result := TDynamicNumber.Create(flip_num);
  OverflowFlag := false;
end;

end.

