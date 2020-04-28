unit DatasetHelper;

interface

uses sysutils, data.db, system.generics.collections, ioutils;

type
  TDataStringArray = array of string;
  TDataFieldArray = array of TField;
  TDataVariantArray = array of Variant;

  /// <summary>
  /// Interface for dataset helper functions
  /// </summary>

  IDatasetRecord = interface
    /// <summary>
    /// Gets the rec of the current record
    /// </summary>
    function RecNo(): integer;
    /// <summary>
    /// Gets the current field value of the current record
    /// </summary>
    function GetValue(AFieldName: string): Variant; overload;
    function GetValue(AField: TField): Variant; overload;
    /// <summary>
    /// Sets a new value on a field of the current selected rows
    /// </summary>
    function SetValue(AFieldName: string; ANewValue: Variant; APostChanges: boolean = true): IDatasetRecord; overload;
    function SetValue(AField: TField; ANewValue: Variant; APostChanges: boolean = true): IDatasetRecord; overload;
    function SetValue(AFieldNames: TDataStringArray; ANewValues: TDataVariantArray; APostChanges: boolean = true)
      : IDatasetRecord; overload;
    function SetValue(AFields: TDataFieldArray; ANewValues: TDataVariantArray; APostChanges: boolean = true)
      : IDatasetRecord; overload;
    /// <summary>
    /// Execute method in current record
    /// </summary>
    function Execute(AProc: TProc): boolean;
    /// <summary>
    /// Deletes the current selected rows
    /// </summary>
    function Delete(): boolean;
    /// <summary>
    /// Returns array with all values from current row
    /// </summary>
    function AsArray(AFieldNames: TDataStringArray = []): TDataVariantArray;
    /// <summary>
    /// Copy values from array to current row
    /// </summary>
    procedure SetValues(AValues: TDataVariantArray; APostChanges: boolean = true);
    /// <summary>
    /// Creates a new line with the values of the selected line
    /// </summary>
    function CreateCopyRecord(AOverrideFields: TDataStringArray = []; AOverrideValues: TDataVariantArray = [];
      AIgnoreFields: TDataStringArray = []; APostChanges: boolean = true): boolean;
    /// <summary>
    /// Returns array with all values from current row
    /// </summary>
    function CreateCopyRecordToDataset(ATargetDataset: TDataset; AOverrideFields: TDataStringArray = [];
      AOverrideValues: TDataVariantArray = []; AIgnoreFields: TDataStringArray = []; APostChanges: boolean = true): boolean;
  end;

  IDatasetRecList = interface
    /// <summary>
    /// Gets the minimum value of a field
    /// If field is not a number type, an exception is thrown
    /// </summary>
    function Min(AFieldName: string): Variant; overload;
    function Min(AField: TField): Variant; overload;
    /// <summary>
    /// Gets the maximum value of a field
    /// If field is not a number type, an exception is thrown
    /// </summary>
    function Max(AFieldName: string): Variant; overload;
    function Max(AField: TField): Variant; overload;
    /// <summary>
    /// Gets the sum of values of a field
    /// If field is not a number type, an exception is thrown
    /// </summary>
    function Sum(AFieldName: string): integer; overload;
    function Sum(AField: TField): integer; overload;
    /// <summary>
    /// Gets the average of values of a field
    /// If field is not a number type, an exception is thrown
    /// </summary>
    function Avg(AFieldName: string): Variant; overload;
    function Avg(AField: TField): Variant; overload;
    /// <summary>
    /// Gets the count of selected records
    /// </summary>
    function Count(): integer;
    /// <summary>
    /// Returns a group of rows that match the given expression
    /// </summary>
    function Select(AFieldName: string; AValue: Variant): IDatasetRecList; overload;
    function Select(AField: TField; AValue: Variant): IDatasetRecList; overload;
    /// <summary>
    /// Returns a group of rows that doesnt match the given expression
    /// </summary>
    function SelectNotEqual(AFieldName: string; AValue: Variant): IDatasetRecList; overload;
    function SelectNotEqual(AField: TField; AValue: Variant): IDatasetRecList; overload;
    /// <summary>
    /// Returns a group of rows that match the given expression
    /// </summary>
    function SelectIn(AFieldName: string; AValues: TDataVariantArray): IDatasetRecList; overload;
    function SelectIn(AField: TField; AValues: TDataVariantArray): IDatasetRecList; overload;
    /// <summary>
    /// Returns a group of rows that doesnt match the given expression
    /// </summary>
    function SelectNotIn(AFieldName: string; AValues: TDataVariantArray): IDatasetRecList; overload;
    function SelectNotIn(AField: TField; AValues: TDataVariantArray): IDatasetRecList; overload;
    /// <summary>
    /// Returns the first record of the selection
    /// </summary>
    function First(): IDatasetRecord;
    /// <summary>
    /// Returns the Last record of the selection
    /// </summary>
    function Last(): IDatasetRecord;
    /// <summary>
    /// Sets a new value on a field of the current selected rows
    /// </summary>
    function SetValue(AFieldName: string; ANewValue: Variant; APostChanges: boolean = true): IDatasetRecList; overload;
    function SetValue(AField: TField; ANewValue: Variant; APostChanges: boolean = true): IDatasetRecList; overload;
    function SetValue(AFieldNames: TDataStringArray; ANewValues: TDataVariantArray; APostChanges: boolean = true)
      : IDatasetRecList; overload;
    function SetValue(AFields: TDataFieldArray; ANewValues: TDataVariantArray; APostChanges: boolean = true)
      : IDatasetRecList; overload;
    /// <summary>
    /// Loop current result list
    /// </summary>
    procedure ForEach(AProc: TProc);
    procedure ForEachReversed(AProc: TProc);
    /// <summary>
    /// Deletes the current selected rows
    /// </summary>
    function Delete(): integer;
    /// <summary>
    /// Returns current selected rows as a list with array with all values
    /// </summary>
    function AsList(AFieldNames: TDataStringArray = []): TList<TDataVariantArray>;
    /// <summary>
    /// Returns current selected rows as a array with array with all values
    /// </summary>
    function AsArray(AFieldNames: TDataStringArray = []): TArray<TDataVariantArray>;
  end;

  /// <summary>
  /// Class that implements dataset single record helper functions
  /// </summary>
  TDatasetRecord = class(TInterfacedObject, IDatasetRecord)
  private
    FDataset: TDataset;
    FIndex: integer;
    /// <summary>
    /// Moves to record, edits,  executes function and return to current record
    /// </summary>
    procedure MoveToRecordEditAndReturn(APostChanges: boolean; AProc: TProc);
    /// <summary>
    /// Moves to record, executes function and return to current record
    /// </summary>
    procedure MoveToRecordAndReturn(AProc: TProc);
    constructor Create(ADataset: TDataset; AIndex: integer);
  public
    /// <summary>
    /// Returns array with all values from current row
    /// </summary>
    function AsArray(AFieldNames: TDataStringArray = []): TDataVariantArray;
    /// <summary>
    /// Sets a new value on a field of the current selected rows
    /// </summary>
    function SetValue(AFieldName: string; ANewValue: Variant; APostChanges: boolean = true): IDatasetRecord; overload;
    function SetValue(AField: TField; ANewValue: Variant; APostChanges: boolean = true): IDatasetRecord; overload;
    function SetValue(AFieldNames: TDataStringArray; ANewValues: TDataVariantArray; APostChanges: boolean = true)
      : IDatasetRecord; overload;
    function SetValue(AFields: TDataFieldArray; ANewValues: TDataVariantArray; APostChanges: boolean = true)
      : IDatasetRecord; overload;
    /// <summary>
    /// Copy values from array to current row
    /// </summary>
    procedure SetValues(AValues: TDataVariantArray; APostChanges: boolean = true);
    /// <summary>
    /// Gets the current field value of the current record
    /// </summary>
    function GetValue(AFieldName: string): Variant; overload;
    function GetValue(AField: TField): Variant; overload;
    /// <summary>
    /// Creates a new line with the values of the selected line
    /// </summary>
    function CreateCopyRecord(AOverrideFields: TDataStringArray = []; AOverrideValues: TDataVariantArray = [];
      AIgnoreFields: TDataStringArray = []; APostChanges: boolean = true): boolean;
    /// <summary>
    /// Returns array with all values from current row
    /// </summary>
    function CreateCopyRecordToDataset(ATargetDataset: TDataset; AOverrideFields: TDataStringArray = [];
      AOverrideValues: TDataVariantArray = []; AIgnoreFields: TDataStringArray = []; APostChanges: boolean = true): boolean;
    /// <summary>
    /// Gets the rec of the first record
    /// </summary>
    function RecNo(): integer;
    /// <summary>
    /// Execute method in current record
    /// </summary>
    function Execute(AProc: TProc): boolean;
    /// <summary>
    /// Deletes the current selected rows
    /// </summary>
    function Delete(): boolean;
  end;

  /// <summary>
  /// Class that implements dataset helper functions
  /// </summary>
  TDatasetRecList = class(TInterfacedObject, IDatasetRecList)
  private
    FDataset: TDataset;
    FList: TList<integer>;
    FAll: boolean;
  public
    // Interface functions
    /// <summary>
    /// Gets the minimum value of a field
    /// If field is not a number type, an exception is thrown
    /// </summary>
    function Min(AFieldName: string): Variant; overload;
    function Min(AField: TField): Variant; overload;
    /// <summary>
    /// Gets the maximum value of a field
    /// If field is not a number type, an exception is thrown
    /// </summary>
    function Max(AFieldName: string): Variant; overload;
    function Max(AField: TField): Variant; overload;
    /// <summary>
    /// Gets the sum of values of a field
    /// If field is not a number type, an exception is thrown
    /// </summary>
    function Sum(AFieldName: string): integer; overload;
    function Sum(AField: TField): integer; overload;
    /// <summary>
    /// Gets the average of values of a field
    /// If field is not a number type, an exception is thrown
    /// </summary>
    function Avg(AFieldName: string): Variant; overload;
    function Avg(AField: TField): Variant; overload;
    /// <summary>
    /// Gets the count of selected records
    /// </summary>
    function Count(): integer;
    /// <summary>
    /// Sets a new value on a field of the current selected rows
    /// </summary>
    function SetValue(AFieldName: string; ANewValue: Variant; APostChanges: boolean = true): IDatasetRecList; overload;
    function SetValue(AField: TField; ANewValue: Variant; APostChanges: boolean = true): IDatasetRecList; overload;
    function SetValue(AFieldNames: TDataStringArray; ANewValues: TDataVariantArray; APostChanges: boolean = true)
      : IDatasetRecList; overload;
    function SetValue(AFields: TDataFieldArray; ANewValues: TDataVariantArray; APostChanges: boolean = true)
      : IDatasetRecList; overload;
    /// <summary>
    /// Returns a group of rows that match the given expression
    /// </summary>
    function Select(AFieldName: string; AValue: Variant): IDatasetRecList; overload;
    function Select(AField: TField; AValue: Variant): IDatasetRecList; overload;
    /// <summary>
    /// Returns a group of rows that doesnt match the given expression
    /// </summary>
    function SelectNotEqual(AFieldName: string; AValue: Variant): IDatasetRecList; overload;
    function SelectNotEqual(AField: TField; AValue: Variant): IDatasetRecList; overload;
    /// <summary>
    /// Returns a group of rows that match the given expression
    /// </summary>
    function SelectIn(AFieldName: string; AValues: TDataVariantArray): IDatasetRecList; overload;
    function SelectIn(AField: TField; AValues: TDataVariantArray): IDatasetRecList; overload;
    /// <summary>
    /// Returns a group of rows that doesnt match the given expression
    /// </summary>
    function SelectNotIn(AFieldName: string; AValues: TDataVariantArray): IDatasetRecList; overload;
    function SelectNotIn(AField: TField; AValues: TDataVariantArray): IDatasetRecList; overload;
    /// <summary>
    /// Returns the first record of the selection
    /// </summary>
    function First(): IDatasetRecord;
    /// <summary>
    /// Returns the Last record of the selection
    /// </summary>
    function Last(): IDatasetRecord;
    /// <summary>
    /// Loop current result list
    /// </summary>
    procedure ForEach(AProc: TProc);
    procedure ForEachReversed(AProc: TProc);
    /// <summary>
    /// Deletes the current selected rows
    /// </summary>
    function Delete(): integer;
    /// <summary>
    /// Returns current selected rows as a list with array with all values
    /// </summary>
    function AsList(AFieldNames: TDataStringArray = []): TList<TDataVariantArray>;
    /// <summary>
    /// Returns current selected rows as a array with array with all values
    /// </summary>
    function AsArray(AFieldNames: TDataStringArray = []): TArray<TDataVariantArray>;
    constructor Create(ADataset: TDataset);
    destructor Destroy(); override;
  end;

  /// <summary>
  /// Dataset helper taht implements first selectors
  /// </summary>
  TDatasetHelper = class helper for data.db.TDataset
    /// <summary>
    /// Returns a group of rows that match the given expression
    /// </summary>
    function Select(AFieldName: string; AValue: Variant): IDatasetRecList; overload;
    function Select(AField: TField; AValue: Variant): IDatasetRecList; overload;
    /// <summary>
    /// Returns a group of rows that doesnt match the given expression
    /// </summary>
    function SelectNotEqual(AFieldName: string; AValue: Variant): IDatasetRecList; overload;
    function SelectNotEqual(AField: TField; AValue: Variant): IDatasetRecList; overload;
    /// <summary>
    /// Returns a group of rows that match the given expression
    /// </summary>
    function SelectIn(AFieldName: string; AValues: TDataVariantArray): IDatasetRecList; overload;
    function SelectIn(AField: TField; AValues: TDataVariantArray): IDatasetRecList; overload;
    /// <summary>
    /// Returns a group of rows that doesnt match the given expression
    /// </summary>
    function SelectNotIn(AFieldName: string; AValues: TDataVariantArray): IDatasetRecList; overload;
    function SelectNotIn(AField: TField; AValues: TDataVariantArray): IDatasetRecList; overload;
    /// <summary>
    /// Returns all dataset rows
    /// </summary>
    function All: IDatasetRecList;
    /// <summary>
    /// Returns current dataset row
    /// </summary>
    function Current: IDatasetRecord;
  end;

implementation

uses variants, StrUtils;

{ TResultList }
/// <summary>
/// Gets the count of selected records
/// </summary>
function TDatasetRecList.Count: integer;
begin
  if FAll then
    Result := FDataset.RecordCount
  else
    Result := FList.Count;
end;

constructor TDatasetRecList.Create(ADataset: TDataset);
begin
  FDataset := ADataset;
  FList := TList<integer>.Create;
  FAll := true;
end;

function TDatasetRecList.Delete: integer;
var
  LIndex: integer;
  LResult: integer;
begin
  LResult := 0;
  FDataset.DisableControls;
  try
    if FAll then
    begin
      // Loop entire dataset
      FDataset.Last;
      while not FDataset.bof do
      begin
        FDataset.Delete;
        inc(LResult);
      end;
    end
    else
      // Lopp current result list
      for LIndex := FList.Count - 1 downto 0 do
      begin
        FDataset.RecNo := FList[LIndex];
        FDataset.Delete;
        inc(LResult);
      end;
  finally
    FDataset.EnableControls;
    Result := LResult;
  end;
end;

destructor TDatasetRecList.Destroy;
begin
  FList.Destroy;
  inherited;
end;

/// <summary>
/// Loop current result list
/// </summary>
procedure TDatasetRecList.ForEach(AProc: TProc);
var
  LIndex: integer;
begin
  FDataset.DisableControls;
  try
    if FAll then
    begin
      // Loop entire dataset
      FDataset.First;
      while not FDataset.eof do
      begin
        AProc();
        FDataset.Next;
      end;
    end
    else
      // Lopp current result list
      for LIndex in FList do
      begin
        FDataset.RecNo := LIndex;
        AProc();
      end;
  finally
    FDataset.EnableControls;
  end;
end;

/// <summary>
/// Loop current result list
/// </summary>
procedure TDatasetRecList.ForEachReversed(AProc: TProc);
var
  LIndex: integer;
begin
  FDataset.DisableControls;
  try
    if FAll then
    begin
      // Loop entire dataset
      FDataset.Last;
      while not FDataset.bof do
      begin
        AProc();
        FDataset.Prior;
      end;
    end
    else
      // Lopp current result list
      for LIndex := FList.Count - 1 downto 0 do
      begin
        FDataset.RecNo := FList[LIndex];
        AProc();
      end;
  finally
    FDataset.EnableControls;
  end;
end;

/// <summary>
/// Returns the first record of the selection
/// </summary>
function TDatasetRecList.First: IDatasetRecord;
begin
  if FAll then
    Result := TDatasetRecord.Create(FDataset, 1)
  else if FList.Count > 0 then
    Result := TDatasetRecord.Create(FDataset, FList.First)
  else
    Result := TDatasetRecord.Create(nil, -1);
end;

/// <summary>
/// Returns the Last record of the selection
/// </summary>
function TDatasetRecList.Last: IDatasetRecord;
begin
  if FAll then
    Result := TDatasetRecord.Create(FDataset, FDataset.RecordCount)
  else if FList.Count > 0 then
    Result := TDatasetRecord.Create(FDataset, FList.Last)
  else
    Result := TDatasetRecord.Create(nil, -1);
end;

/// <summary>
/// Gets the average of values of a field
/// If field is not a number type, an exception is thrown
/// </summary>
function TDatasetRecList.Avg(AFieldName: string): Variant;
begin
  Result := Avg(FDataset.FieldByName(AFieldName));
end;

/// <summary>
/// Gets the average of values of a field
/// If field is not a number type, an exception is thrown
/// </summary>
function TDatasetRecList.AsList(AFieldNames: TDataStringArray): TList<TDataVariantArray>;
var
  LList: TList<TDataVariantArray>;
begin
  LList := TList<TDataVariantArray>.Create;
  ForEach(
    procedure
    begin
      LList.Add(FDataset.Current.AsArray(AFieldNames));
    end);

  Result := LList;
end;

/// <summary>
/// Returns current selected rows as a array with array with all values
/// </summary>
function TDatasetRecList.AsArray(AFieldNames: TDataStringArray = []): TArray<TDataVariantArray>;
var
  LArray: TArray<TDataVariantArray>;
  LIndex: integer;
begin
  Setlength(LArray, Count);
  LIndex := 0;
  ForEach(
    procedure
    begin
      LArray[LIndex] := FDataset.Current.AsArray(AFieldNames);
      inc(LIndex);
    end);

  Result := LArray;
end;

function TDatasetRecList.Avg(AField: TField): Variant;
var
  LCount: integer;
begin
  LCount := Count;
  if LCount > 0 then
    Result := Sum(AField) / LCount
  else
    Result := Null;
end;

/// <summary>
/// Gets the maximum value of a field
/// If field is not a number type, an exception is thrown
/// </summary>
function TDatasetRecList.Max(AFieldName: string): Variant;
begin
  Result := Max(FDataset.FieldByName(AFieldName));
end;

/// <summary>
/// Gets the maximum value of a field
/// If field is not a number type, an exception is thrown
/// </summary>
function TDatasetRecList.Max(AField: TField): Variant;
var
  LMax: Variant;
begin
  LMax := Null;
  ForEach(
    procedure
    begin
      if (LMax = Null) or (AField.Value > LMax) then
        LMax := AField.Value;
    end);

  Result := LMax;
end;

/// <summary>
/// Gets the minimum value of a field
/// If field is not a number type, an exception is thrown
/// </summary>
function TDatasetRecList.Min(AFieldName: string): Variant;
begin
  Result := Min(FDataset.FieldByName(AFieldName));
end;

/// <summary>
/// Gets the minimum value of a field
/// If field is not a number type, an exception is thrown
/// </summary>
function TDatasetRecList.Min(AField: TField): Variant;
var
  LMin: Variant;
begin
  LMin := Null;
  ForEach(
    procedure
    begin
      if (LMin = Null) or (AField.Value < LMin) then
        LMin := AField.Value;
    end);

  Result := LMin;
end;

/// <summary>
/// Gets the maximum value of a field
/// If field is not a number type, an exception is thrown
/// </summary>
function TDatasetRecList.Sum(AFieldName: string): integer;
begin
  Result := Sum(FDataset.FieldByName(AFieldName));
end;

/// <summary>
/// Gets the maximum value of a field
/// If field is not a number type, an exception is thrown
/// </summary>
function TDatasetRecList.Sum(AField: TField): integer;
var
  LTotal: integer;
begin
  LTotal := 0;
  ForEach(
    procedure
    begin
      LTotal := LTotal + AField.Value;
    end);

  Result := LTotal;
end;

/// <summary>
/// Sets a new value on a field of the current selected rows
/// </summary>
function TDatasetRecList.SetValue(AField: TField; ANewValue: Variant; APostChanges: boolean = true): IDatasetRecList;
begin
  ForEach(
    procedure
    begin
      TDatasetRecord.Create(FDataset, FDataset.RecNo).SetValue(AField, ANewValue, APostChanges);
    end);

  Result := self;
end;

/// <summary>
/// Sets a new value on a field of the current selected rows
/// </summary>
function TDatasetRecList.SetValue(AFieldName: string; ANewValue: Variant; APostChanges: boolean = true): IDatasetRecList;
begin
  Result := SetValue(FDataset.FieldByName(AFieldName), ANewValue);
end;

function TDatasetRecList.SetValue(AFields: TDataFieldArray; ANewValues: TDataVariantArray; APostChanges: boolean = true)
  : IDatasetRecList;
begin
  ForEach(
    procedure
    begin
      TDatasetRecord.Create(FDataset, FDataset.RecNo).SetValue(AFields, ANewValues, APostChanges);
    end);

  Result := self;
end;

function TDatasetRecList.SetValue(AFieldNames: TDataStringArray; ANewValues: TDataVariantArray; APostChanges: boolean = true)
  : IDatasetRecList;
var
  LFields: TDataFieldArray;
  LIndex: integer;
begin
  Setlength(LFields, Length(AFieldNames));
  for LIndex := 0 to Length(AFieldNames) - 1 do
    LFields[LIndex] := FDataset.FieldByName(AFieldNames[LIndex]);
  Result := SetValue(LFields, ANewValues, APostChanges);
end;

/// <summary>
/// Returns a group of rows that match the given expression
/// </summary>
function TDatasetRecList.Select(AFieldName: string; AValue: Variant): IDatasetRecList;
begin
  Result := Select(FDataset.FieldByName(AFieldName), AValue);
end;

/// <summary>
/// Returns a group of rows that match the given expression
/// </summary>
function TDatasetRecList.Select(AField: TField; AValue: Variant): IDatasetRecList;
var
  LList: TList<integer>;
begin
  LList := TList<integer>.Create;
  try
    ForEach(
      procedure
      begin
        if AField.Value = AValue then
          LList.Add(FDataset.RecNo);
      end);
  finally
    FList.Clear;
    FList.AddRange(LList);
    LList.Destroy;
  end;

  FAll := false;
  Result := self;
end;

function TDatasetRecList.SelectIn(AFieldName: string; AValues: TDataVariantArray): IDatasetRecList;
begin
  Result := SelectIn(FDataset.FieldByName(AFieldName), AValues);
end;

function TDatasetRecList.SelectIn(AField: TField; AValues: TDataVariantArray): IDatasetRecList;
var
  LList: TList<integer>;
begin
  LList := TList<integer>.Create;
  try
    ForEach(
      procedure
      var
        LItem: Variant;
      begin
        for LItem in AValues do
          if LItem = AField.Value then
          begin
            LList.Add(FDataset.RecNo);
            break;
          end;
      end);
  finally
    FList.Clear;
    FList.AddRange(LList);
    LList.Destroy;
  end;

  FAll := false;
  Result := self;
end;

/// <summary>
/// Returns a group of rows that doesnt match the given expression
/// </summary>
function TDatasetRecList.SelectNotEqual(AField: TField; AValue: Variant): IDatasetRecList;
var
  LList: TList<integer>;
begin
  LList := TList<integer>.Create;
  try
    ForEach(
      procedure
      begin
        if AField.Value <> AValue then
          LList.Add(FDataset.RecNo);
      end);
  finally
    FList.Clear;
    FList.AddRange(LList);
    LList.Destroy;
  end;

  FAll := false;
  Result := self;
end;

function TDatasetRecList.SelectNotIn(AFieldName: string; AValues: TDataVariantArray): IDatasetRecList;
begin
  Result := SelectNotIn(FDataset.FieldByName(AFieldName), AValues);
end;

function TDatasetRecList.SelectNotIn(AField: TField; AValues: TDataVariantArray): IDatasetRecList;
var
  LList: TList<integer>;
begin
  LList := TList<integer>.Create;
  try
    ForEach(
      procedure
      var
        LItem: Variant;
        LInArray: boolean;
      begin
        LInArray:=false;
        for LItem in AValues do
          if LItem = AField.Value then
          begin
            LInArray:=true;
            break;
          end;

        if not LInArray then
          LList.Add(FDataset.RecNo);
      end);
  finally
    FList.Clear;
    FList.AddRange(LList);
    LList.Destroy;
  end;

  FAll := false;
  Result := self;
end;

/// <summary>
/// Returns a group of rows that doesnt match the given expression
/// </summary>
function TDatasetRecList.SelectNotEqual(AFieldName: string; AValue: Variant): IDatasetRecList;
begin
  Result := SelectNotEqual(FDataset.FieldByName(AFieldName), AValue);
end;

{ TDatasetHelper }

/// <summary>
/// Returns all dataset rows
/// </summary>
function TDatasetHelper.All: IDatasetRecList;
begin
  Result := TDatasetRecList.Create(self);
end;

/// <summary>
/// Returns a group of rows that match the given expression
/// </summary>
function TDatasetHelper.Select(AFieldName: string; AValue: Variant): IDatasetRecList;
begin
  Result := TDatasetRecList.Create(self).Select(AFieldName, AValue);
end;

function TDatasetHelper.Select(AField: TField; AValue: Variant): IDatasetRecList;
begin
  Result := TDatasetRecList.Create(self).Select(AField, AValue);
end;

/// <summary>
/// Returns a group of rows that match the given expression
/// </summary>
function TDatasetHelper.SelectIn(AFieldName: string; AValues: TDataVariantArray): IDatasetRecList;
begin
  Result := TDatasetRecList.Create(self).SelectIn(AFieldName, AValues);
end;

function TDatasetHelper.SelectIn(AField: TField; AValues: TDataVariantArray): IDatasetRecList;
begin
  Result := TDatasetRecList.Create(self).SelectIn(AField, AValues);
end;

/// <summary>
/// Returns a group of rows that dosnt match the given expression
/// </summary>
function TDatasetHelper.SelectNotEqual(AFieldName: string; AValue: Variant): IDatasetRecList;
begin
  Result := TDatasetRecList.Create(self).SelectNotEqual(AFieldName, AValue);
end;

function TDatasetHelper.SelectNotEqual(AField: TField; AValue: Variant): IDatasetRecList;
begin
  Result := TDatasetRecList.Create(self).SelectNotEqual(AField, AValue);
end;

/// <summary>
/// Returns a group of rows that doesnt match the given expression
/// </summary>
function TDatasetHelper.SelectNotIn(AFieldName: string; AValues: TDataVariantArray): IDatasetRecList;
begin
  Result := TDatasetRecList.Create(self).SelectNotIn(AFieldName, AValues);
end;

function TDatasetHelper.SelectNotIn(AField: TField; AValues: TDataVariantArray): IDatasetRecList;
begin
  Result := TDatasetRecList.Create(self).SelectNotIn(AField, AValues);
end;

/// <summary>
/// Returns current dataset row
/// </summary>
function TDatasetHelper.Current: IDatasetRecord;
begin
  Result := TDatasetRecord.Create(self, self.RecNo);
end;

{ TDatasetRecord }

function TDatasetRecord.AsArray(AFieldNames: TDataStringArray = []): TDataVariantArray;
var
  LResult: TDataVariantArray;
begin
  Setlength(LResult, 0);
  MoveToRecordAndReturn(
    procedure
    var
      LIndex: integer;
      LFieldName: string;
    begin
      if Length(AFieldNames) = 0 then
      begin
        // Set Values
        Setlength(LResult, FDataset.FieldCount);
        for LIndex := 0 to FDataset.FieldCount - 1 do
          LResult[LIndex] := FDataset.Fields[LIndex].Value;
      end
      else
      begin
        // Can be improved
        Setlength(LResult, Length(AFieldNames));
        for LIndex := 0 to Length(AFieldNames) - 1 do
          if FDataset.FindField(AFieldNames[LIndex]) <> nil then
            LResult[LIndex] := FDataset.FindField(AFieldNames[LIndex]).Value;
      end;
    end);

  Result := LResult;
end;

constructor TDatasetRecord.Create(ADataset: TDataset; AIndex: integer);
begin
  FDataset := ADataset;
  FIndex := AIndex;
end;

function TDatasetRecord.CreateCopyRecord(AOverrideFields: TDataStringArray; AOverrideValues: TDataVariantArray;
AIgnoreFields: TDataStringArray; APostChanges: boolean): boolean;
begin
  Result := CreateCopyRecordToDataset(FDataset, AOverrideFields, AOverrideValues, AIgnoreFields, APostChanges);
end;

function TDatasetRecord.CreateCopyRecordToDataset(ATargetDataset: TDataset; AOverrideFields: TDataStringArray;
AOverrideValues: TDataVariantArray; AIgnoreFields: TDataStringArray; APostChanges: boolean): boolean;
var
  LIndex: integer;
  LCurrentValues: TDataVariantArray;
begin
  //
  Result := false;
  if ATargetDataset <> nil then
  begin
    ATargetDataset.DisableControls;
    try
      LCurrentValues := AsArray([]);
      ATargetDataset.Append;
      for LIndex := 0 to ATargetDataset.FieldCount - 1 do
      begin
        // Ignore Field
        if MatchText(ATargetDataset.Fields[LIndex].FieldName, AIgnoreFields) then
          continue;

        // Override Field Value
        if MatchText(ATargetDataset.Fields[LIndex].FieldName, AOverrideFields) then
        begin
          ATargetDataset.Fields[LIndex].Value := AOverrideValues
            [IndexText(ATargetDataset.Fields[LIndex].FieldName, AOverrideFields)];
          continue;
        end;

        // Set Value
        ATargetDataset.Fields[LIndex].Value := LCurrentValues[LIndex];

      end;

      if APostChanges then
        ATargetDataset.Post;
    finally
      Result := true;
      ATargetDataset.EnableControls;
    end;
  end;

end;

/// <summary>
/// Deletes the current selected rows
/// </summary>
function TDatasetRecord.Delete: boolean;
var
  LResult: boolean;
begin
  LResult := false;
  MoveToRecordAndReturn(
    procedure
    begin
      try
        FDataset.Delete;
      finally
        LResult := true;
      end;
    end);

  Result := LResult;
end;

/// <summary>
/// Execute method in current record
/// </summary>
function TDatasetRecord.Execute(AProc: TProc): boolean;
var
  LResult: boolean;
begin
  LResult := false;

  MoveToRecordAndReturn(
    procedure
    begin
      try
        AProc();
      finally
        LResult := true;
      end;
    end);

  Result := LResult;
end;

function TDatasetRecord.GetValue(AField: TField): Variant;
var
  LResult: Variant;
begin
  LResult := Null;
  MoveToRecordAndReturn(
    procedure
    begin
      LResult := AField.Value;
    end);

  Result := LResult;
end;

procedure TDatasetRecord.MoveToRecordAndReturn(AProc: TProc);
var
  LPrevRecNo: integer;
begin
  if FIndex > 0 then
  begin
    FDataset.DisableControls;
    try
      LPrevRecNo := FDataset.RecNo;
      FDataset.RecNo := FIndex;
      AProc();
      FDataset.RecNo := LPrevRecNo;
    finally
      FDataset.EnableControls;
    end;
  end;
end;

/// <summary>
/// Moves to record, edits,  executes function and return to current record
/// </summary>
procedure TDatasetRecord.MoveToRecordEditAndReturn(APostChanges: boolean; AProc: TProc);
begin
  MoveToRecordAndReturn(
    procedure
    begin
      if not(FDataset.State in dsEditModes) then
        FDataset.Edit;
      AProc;
      if APostChanges then
        FDataset.Post;
    end);
end;

function TDatasetRecord.GetValue(AFieldName: string): Variant;
begin
  if FDataset = nil then
    Result := Null
  else
    Result := GetValue(FDataset.FieldByName(AFieldName));
end;

/// <summary>
/// Gets the rec of the first record
/// </summary>
function TDatasetRecord.RecNo: integer;
begin
  Result := FIndex;
end;

/// <summary>
/// Sets a new value on a field of the current selected rows
/// </summary>
function TDatasetRecord.SetValue(AFieldName: string; ANewValue: Variant; APostChanges: boolean = true): IDatasetRecord;
begin
  if FDataset = nil then
    Result := self
  else
    Result := SetValue(FDataset.FieldByName(AFieldName), ANewValue, APostChanges);
end;

/// <summary>
/// Sets a new value on a field of the current selected rows
/// </summary>
function TDatasetRecord.SetValue(AField: TField; ANewValue: Variant; APostChanges: boolean = true): IDatasetRecord;
begin
  MoveToRecordEditAndReturn(APostChanges,
    procedure
    begin
      AField.Value := ANewValue;
    end);

  Result := self;
end;

/// <summary>
/// Sets a new value on a field of the current selected rows
/// </summary>
function TDatasetRecord.SetValue(AFieldNames: TDataStringArray; ANewValues: TDataVariantArray; APostChanges: boolean = true)
  : IDatasetRecord;
var
  LFields: TDataFieldArray;
  LIndex: integer;
begin
  if FDataset = nil then
    Result := self
  else
  begin
    Setlength(LFields, Length(AFieldNames));
    for LIndex := 0 to Length(AFieldNames) - 1 do
      LFields[LIndex] := FDataset.FieldByName(AFieldNames[LIndex]);
    Result := SetValue(LFields, ANewValues, APostChanges);
  end;
end;

/// <summary>
/// Sets a new value on a field of the current selected rows
/// </summary>
function TDatasetRecord.SetValue(AFields: TDataFieldArray; ANewValues: TDataVariantArray; APostChanges: boolean = true)
  : IDatasetRecord;
begin
  MoveToRecordEditAndReturn(APostChanges,
    procedure
    var
      LIndex: integer;
    begin
      for LIndex := 0 to Length(AFields) - 1 do
        AFields[LIndex].Value := ANewValues[LIndex];
    end);

  Result := self;
end;

/// <summary>
/// Copy values from array to current row
/// </summary>
procedure TDatasetRecord.SetValues(AValues: TDataVariantArray; APostChanges: boolean = true);
begin
  MoveToRecordEditAndReturn(APostChanges,
    procedure
    var
      LIndex: integer;
    begin
      for LIndex := 0 to Length(AValues) - 1 do
        FDataset.Fields[LIndex].Value := AValues[LIndex];
    end);
end;

end.
