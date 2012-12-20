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

program PalindromicGen;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, DynamicNumber, IniFiles;

const
  MAX_ITERATION_COUNT = 1000;
  MAX_LOOP_LIMIT = 100;
  MIN_LOOP_COUNT = 0;
  OUTPUT_FILE = 'output.txt';

type
  TConfigStruct = record
    OutputFileName : string;
    OutputToScreen : Boolean;
    HoldOnExit : Boolean;
    StartNumber : String;
    LoopLimit : LongInt;
    MaxIterationLimit : LongInt;
  end;

  TPalindromicGen = class(TCustomApplication)
  private
    SysConfig : TConfigStruct;
  protected
    procedure DoRun; override;
    function IsPalindromicNumber(InNum : TDynamicNumber) : Boolean;
    function SeekPalindromicNumber(InNum : TDynamicNumber; out PalindromicNum : TDynamicNumber; out IterCount : LongInt) : Boolean;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

function GetSystemConfig() : TConfigStruct;
var
  cnfg_file : TIniFile;
begin
  cnfg_file := TIniFile.Create('palindromicgen.ini');
  result.OutputFileName := cnfg_file.ReadString('config','outputfile',OUTPUT_FILE);
  result.OutputToScreen:= cnfg_file.ReadBool('config','outputscreen', true);
  result.HoldOnExit:= cnfg_file.ReadBool('config','holdonexit', true);
  result.LoopLimit := cnfg_file.ReadInteger('config','limit',MAX_LOOP_LIMIT);
  result.MaxIterationLimit := cnfg_file.ReadInteger('config', 'maxiterations', MAX_ITERATION_COUNT);
  result.StartNumber := cnfg_file.ReadString('config','startnumber','10');
  freeandnil(cnfg_file);
end;

procedure TPalindromicGen.DoRun;
var
  num_pos, iter_count : LongInt; counter, counter_buffer, out_num, inc_template : TDynamicNumber;
  csv_file : TextFile; staus_code : byte;
begin
  SysConfig := GetSystemConfig();
  AssignFile(csv_file, SysConfig.OutputFileName);
  Rewrite(csv_file);
  num_pos := MIN_LOOP_COUNT;
  counter := TDynamicNumber.Create(SysConfig.StartNumber);
  inc_template := TDynamicNumber.Create('1');
  //this counter buffer is used to avoid "counter" object short circuits
  counter_buffer := TDynamicNumber.Create('1');
  while(num_pos < SysConfig.LoopLimit) do
  begin
    staus_code := 0;
    //palindromic number check point
    if (SeekPalindromicNumber(counter, out_num, iter_count)) then
    begin
      if(SysConfig.OutputToScreen) then
        writeln(counter.GetNumber() + ': Iterations: ' + InttoStr(iter_count + 1) + ' Palindromic Number: ' + out_num.GetNumber());
      staus_code := 1;
    end
    else
    begin
      if(SysConfig.OutputToScreen) then
      begin
        writeln(counter.GetNumber() + ': Maximum iteration count reached');
        writeln(' Current Sum: ' + out_num.GetNumber());
      end;
    end;
    writeln(csv_file, counter.GetNumber()+','+InttoStr(staus_code)+','+InttoStr(iter_count + 1)+','+out_num.GetNumber());
    counter_buffer.SetNumber(counter.GetNumber());
    counter_buffer.AddDynamicNumber(inc_template, counter);
    inc(num_pos);
  end;
  CloseFile(csv_file);
  writeln('Operation Completed');
  if(SysConfig.HoldOnExit) then
    ReadLn;
  Terminate;
end;

function TPalindromicGen.SeekPalindromicNumber(InNum : TDynamicNumber; out PalindromicNum : TDynamicNumber;  out IterCount : LongInt) : Boolean;
var
  loop_count : Longint; num_sum, base_num : TDynamicNumber;
begin
  loop_count := 0;
  result := false;
  base_num := TDynamicNumber.Create(InNum.GetNumber());
  num_sum := TDynamicNumber.Create('');
  while(loop_count < SysConfig.MaxIterationLimit) do
  begin
    base_num.AddDynamicNumber(base_num.FlipNumber(), num_sum);
    if(IsPalindromicNumber(num_sum)) then
    begin
      result := true;
      break;
    end;
    base_num.SetNumber(num_sum.GetNumber());
    inc(loop_count);
  end;
  PalindromicNum := num_sum;
  IterCount := loop_count;
end;

function TPalindromicGen.IsPalindromicNumber(InNum : TDynamicNumber) : Boolean;
var
  tmp_num : TDynamicNumber;
begin
  tmp_num := InNum.FlipNumber();
  result := (tmp_num.GetNumber() = InNum.GetNumber());
  freeandnil(tmp_num);
end;

constructor TPalindromicGen.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TPalindromicGen.Destroy;
begin
  inherited Destroy;
end;

var
  Application: TPalindromicGen;
begin
  Application:=TPalindromicGen.Create(nil);
  Application.Run;
  Application.Free;
end.

