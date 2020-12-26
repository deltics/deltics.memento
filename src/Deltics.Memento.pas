{
  * MIT LICENSE *

  Copyright © 2008 Jolyon Smith

  Permission is hereby granted, free of charge, to any person obtaining a copy of
   this software and associated documentation files (the "Software"), to deal in
   the Software without restriction, including without limitation the rights to
   use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
   of the Software, and to permit persons to whom the Software is furnished to do
   so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.


  * GPL and Other Licenses *

  The FSF deem this license to be compatible with version 3 of the GPL.
   Compatability with other licenses should be verified by reference to those
   other license terms.


  * Contact Details *

  Original author : Jolyon Direnko-Smith
  e-mail          : jsmith@deltics.co.nz
  github          : deltics/deltics.rtl
}

{$i deltics.memento.inc}

  unit Deltics.Memento;


interface

  uses
    Deltics.InterfacedObjects;


  type
    TMementoState = (
                     msValid,
                     msDiscarded,
                     msRecalled
                    );


    IMemento = interface
    ['{AFF923DC-53A0-4397-B8FF-B9AD3D173541}']
      procedure Discard;
      procedure Recall;
      procedure Refresh;
    end;


    TMemento = class(TComInterfacedObject, IMemento)
    private
      fState: TMementoState;
      property State: TMementoState read fState;
    protected
      procedure DoRecall; virtual; abstract;
      procedure DoRefresh; virtual; abstract;
    public
      destructor Destroy; override;
      procedure AfterConstruction; override;
      procedure Discard;
      procedure Recall;
      procedure Refresh;
    end;



implementation

  uses
    TypInfo,
    Deltics.Exceptions;



{ TMemento --------------------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMemento.AfterConstruction;
  begin
    inherited;

    Refresh;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  destructor TMemento.Destroy;
  begin
    if (State = msValid) then
      Recall;

    inherited;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMemento.Discard;
  begin
    fState := msDiscarded;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMemento.Recall;
  begin
    case fState of
      msValid : begin
                  DoRecall;
                  fState := msRecalled;
                end;

      msDiscarded : raise EInvalidOperation.CreateFmt('Memento (%s) has been discarded', [ClassName]);
      msRecalled  : raise EInvalidOperation.CreateFmt('Memento (%s) has already been recalled', [ClassName]);
    else
      raise ENotImplemented.CreateFmt('Unsupported MementoState (%s)', [GetEnumName(TypeInfo(TMementoState), Ord(fState))]);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMemento.Refresh;
  begin
    DoRefresh;
    fState := msValid;
  end;


end.
