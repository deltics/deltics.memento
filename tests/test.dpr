
program test;

{$apptype console}

{$i deltics.inc}

uses
  Deltics.Smoketest,
  Deltics.Memento in '..\src\Deltics.Memento.pas',
  Test.Memento in 'Test.Memento.pas';

begin
  TestRun.Test(TMementoTests);
end.
