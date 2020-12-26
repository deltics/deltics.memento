
  unit Test.Memento;


interface

  uses
    Deltics.Smoketest,
    Deltics.Memento;


  type
    TMementoSpy = class(TMemento)
    protected
      procedure DoRecall; override;
      procedure DoRefresh; override;
    end;


    TMementoTests = class(TTest)
      procedure SetupMethod;
      procedure TeardownMethod;
      procedure RecallingADiscardedMementoIsAnInvalidOperation;
      procedure RecallingAMementoMoreThanOnceIsAnInvalidOperation;
      procedure RecallingAValidMementoIsSuccessful;
      procedure ValidMementoGoingOutOfScopeIsRecalledAutomatically;
      procedure DiscardedMementoGoingOutOfScopeIsNotRecalled;
      procedure RefreshingADiscardedMementoIsSuccessful;
      procedure RefreshingAMementoMoreThanOnceIsSuccessful;
      procedure RefreshingAValidMementoIsSuccessful;
    end;


implementation

  uses
    Deltics.Exceptions;


  var
    SpyWasRecalled: Boolean = FALSE;
    SpyWasRefreshed: Boolean = FALSE;
    sut: IMemento;


{ TMementoSpy ------------------------------------------------------------------------------------ }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMementoSpy.DoRecall;
  begin
    SpyWasRecalled := TRUE;
  end;

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMementoSpy.DoRefresh;
  begin
    SpyWasRefreshed := TRUE;
  end;



{ TTestMemento ----------------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMementoTests.SetupMethod;
  begin
    SpyWasRecalled  := FALSE;
    SpyWasRefreshed := FALSE;

    sut := TMementoSpy.Create;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMementoTests.TeardownMethod;
  begin
    sut := NIL;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMementoTests.RecallingADiscardedMementoIsAnInvalidOperation;
  begin
    Test.RaisesException(EInvalidOperation, 'Memento (TMementoSpy) has been discarded');

    sut.Discard;
    sut.Recall;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMementoTests.RecallingAMementoMoreThanOnceIsAnInvalidOperation;
  begin
    Test.RaisesException(EInvalidOperation, 'Memento (TMementoSpy) has already been recalled');

    sut.Recall;
    sut.Recall;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMementoTests.RecallingAValidMementoIsSuccessful;
  begin
    sut.Recall;

    Test('Memento was recalled').Assert(SpyWasRecalled);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMementoTests.ValidMementoGoingOutOfScopeIsRecalledAutomatically;

    procedure CreateScopedMemento;
    var
      scoped: IMemento;
    begin
      scoped := TMementoSpy.Create;
    end;

  begin
    Test('Memento was not yet recalled').Assert(NOT SpyWasRecalled);

    CreateScopedMemento;

    Test('Memento was recalled').Assert(SpyWasRecalled);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMementoTests.DiscardedMementoGoingOutOfScopeIsNotRecalled;

    procedure CreateAndDiscardScopedMemento;
    var
      scoped: IMemento;
    begin
      scoped := TMementoSpy.Create;
      scoped.Discard;
    end;

  begin
    Test('Memento was not yet recalled').Assert(NOT SpyWasRecalled);

    CreateAndDiscardScopedMemento;

    Test('Memento was not recalled').Assert(NOT SpyWasRecalled);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMementoTests.RefreshingADiscardedMementoIsSuccessful;
  begin
    Test('Memento was not yet recalled').Assert(NOT SpyWasRecalled);
    Test('Memento was initially refreshed').Assert(SpyWasRefreshed);

    SpyWasRefreshed := FALSE;

    sut.Discard;
    sut.Refresh;

    Test('Memento was not recalled').Assert(NOT SpyWasRecalled);
    Test('Memento was refreshed again').Assert(SpyWasRefreshed);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMementoTests.RefreshingAMementoMoreThanOnceIsSuccessful;
  begin
    Test('Memento was not yet recalled').Assert(NOT SpyWasRecalled);
    Test('Memento was initially refreshed').Assert(SpyWasRefreshed);

    SpyWasRefreshed := FALSE;

    sut.Refresh;
    sut.Refresh;

    Test('Memento was not recalled').Assert(NOT SpyWasRecalled);
    Test('Memento was refreshed again').Assert(SpyWasRefreshed);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TMementoTests.RefreshingAValidMementoIsSuccessful;
  begin
    Test('Memento was not yet recalled').Assert(NOT SpyWasRecalled);
    Test('Memento was initially refreshed').Assert(SpyWasRefreshed);

    SpyWasRefreshed := FALSE;

    sut.Refresh;

    Test('Memento was not recalled').Assert(NOT SpyWasRecalled);
    Test('Memento was refreshed again').Assert(SpyWasRefreshed);
  end;




end.
