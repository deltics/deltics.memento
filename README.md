# Deltics.Memento

This packages provides a base class for implementing auto-disposed objects that can be used to
recall some state that is useful to an application or framework.  The base implementation provides
no state persistence or recall of it's own.  This must be provided by applications or frameworks
deriving their own classes to add the required state and override the `DoRecall` method to re-apply
that stored state as required.


The canonical example is a StreamPositionMemento (see: Deltics.Streams) which records the Position
of a specific stream at initialisation and then restores the position when recalled.  This memento
can then be used in code which wish to read from a stream but ensure that the stream Position is
restored to the original value once complete.

```
  var
    orgPos: IMemento;
  begin
    orgPos := TStreamPositionMemento.Create(aStream);

    // Some processing of the stream
  end;
```

Upon completion of the above method, the orgPos memento falls out of scope and is automatically
destroyed, causing the memento to be recalled, which in this case will reset the Position property
of aStream to the value it had when the memento was created.

If the state held by a memento should not be recalled in some circumstances then it should be
discarded:

```
  var
    orgPos: IMemento;
  begin
    orgPos := TStreamPositionMemento.Create(aStream);

    // Some processing of the stream

    if someCondition then
      orgPos.Discard;
  end;
```

Similarly, if the state held by a memento should be recalled explicitly, before the memento is
destroyed, then it may be explicitly recalled:

```
  var
    orgPos: IMemento;
  begin
    orgPos := TStreamPositionMemento.Create(aStream);

    // Some processing of the stream

    if someCondition then
      orgPos.Recall;
  end;
```

If at any point a memento needs to be refreshed, to update its state, then Refresh may be called
explicitly.  Refreshing a memento resets any Discarded or previously Recalled state (the refreshed
state in the memento may be [again] Discarded or Recalled).


## Invalid Operations
The following will cause an EInvalidOperation exception at runtime:

* Attempting to explicitly Recall a discarded memento
* Attempting to explicitly Recall a memento that has already been recalled


## Implementing a Memento Class

Three fundamentals are required when implementing a memento:

1. A constructor (and any required class member variables) to retain references that will be
   required to obtain and re-apply the state of interest.  e.g. the in the case of
   TStreamPositionMemento, a reference to the stream and a variable to hold the current value of
   the stream Position property (to be applied when recalled);

2. Override the DoRefresh protected method to capture the state of interest.  This method is called
   after the constructor.  Additionally capturing state in the constructor is unnecessary;

3. Override the DoRecall protected method to re-apply the captured state.
