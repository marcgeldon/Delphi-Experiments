{*******************************************************************************
  Blood pressure Database - Small Firemonkey Database Application Example
  use it in Embarcadero Delphi 10 Seattle Update 1

  Author: Marc Geldon, Ludwigshafen, Germany
  https://github.com/marcgeldon/delphi_experiments

  The above author notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
  IN THE SOFTWARE.

  the single file database controller
*******************************************************************************}
unit component_singlefiledatabase;

interface
uses System.SysUtils, System.Classes, System.IOUtils, component_database,
Data.DB, Datasnap.DBClient, FMX.Dialogs,System.UITypes;

type
  TMGSingleFileDatabaseController = class(TMGDatabaseController)
  private
    FApplicationTitle: String;
    FDatabasePath: String;
    FDataSet: TClientDataSet;
    FDatabaseFileExtension: String;
    FDatabaseFileFilter: String;
    FDefaultDatabaseFilename: String;
    FOpenDatabaseFilename: String;

    procedure SetApplicationTitle(Title: String);
  public
    constructor Create(AOwner: TComponent); override;
    property ApplicationTitle: String read FApplicationTitle write SetApplicationTitle;
    procedure ConfigureOpenDialog(OpenDialog: TOpenDialog);
    procedure ConfigureSaveDialog(SaveDialog: TSaveDialog);
    procedure EnsureDatabasePathExists;
    procedure EnsureDataIsPosted;
    function ExecuteOpenDialog: Boolean;
    function ExecuteSaveDialog: Boolean;
    function HasDataChanged: Boolean;
    procedure LoadDatabaseFromFile(Filename: String = '');
    procedure NewDatabase;
    procedure SaveDatabaseToFile(Filename: String = '');
    procedure UpdateDatabaseFileFilter;

    property DataSet: TClientDataSet read FDataSet write FDataSet;
    property DatabasePath: String read FDatabasePath write FDatabasePath;
    property DatabaseFileExtension: String read FDatabaseFileExtension write FDatabaseFileExtension;
    property DatabaseFileFilter: String read FDatabaseFileFilter write FDatabaseFileFilter;
    property DefaultDatabaseFilename: String read FDefaultDatabaseFilename write FDefaultDatabaseFilename;
    property OpenDatabaseFilename: String read FOpenDatabaseFilename;
  end;

implementation

{ TMGSingleFileDatabase }

procedure TMGSingleFileDatabaseController.ConfigureOpenDialog(OpenDialog: TOpenDialog);
begin
  OpenDialog.DefaultExt := FDatabaseFileExtension;
  OpenDialog.Filter := FDatabaseFileFilter;
end;

procedure TMGSingleFileDatabaseController.ConfigureSaveDialog(SaveDialog: TSaveDialog);
var
  Filename: String;
begin
  if (FOpenDatabaseFilename <> '') then
    Filename := FOpenDatabaseFilename
  else
    Filename := DatabasePath + DefaultDatabaseFilename;

  SaveDialog.DefaultExt := FDatabaseFileExtension;
  SaveDialog.Filter := FDatabaseFileFilter;
  SaveDialog.Options := SaveDialog.Options +
                        [System.UITypes.TOpenOption.ofOverwritePrompt,
                         System.UITypes.TOpenOption.ofExtensionDifferent];
  SaveDialog.InitialDir := ExtractFilePath(Filename);
  SaveDialog.FileName := ExtractFileName(Filename);
end;

constructor TMGSingleFileDatabaseController.Create(AOwner: TComponent);
begin
  inherited;

  SetApplicationTitle('Database Application');
  FDatabaseFileExtension := '.xml';
  FDefaultDatabaseFilename := 'database' + FDatabaseFileExtension;
  UpdateDatabaseFileFilter;
end;

procedure TMGSingleFileDatabaseController.EnsureDatabasePathExists;
begin
  // if the default database path does not exist, we create it (in the user document directory)
  if not DirectoryExists(FDatabasePath) then
    ForceDirectories(FDatabasePath);
end;

procedure TMGSingleFileDatabaseController.EnsureDataIsPosted;
begin
  if (FDataSet.State in [TDataSetState.dsEdit, TDataSetState.dsInsert]) then
    FDataSet.Post;
end;

function TMGSingleFileDatabaseController.ExecuteOpenDialog: Boolean;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(Self);
  try
    ConfigureOpenDialog(OpenDialog);

    Result := OpenDialog.Execute;
    if Result then
      if System.SysUtils.FileExists(OpenDialog.FileName) then
        LoadDatabaseFromFile(OpenDialog.FileName);
  finally
    OpenDialog.Free;
  end;
end;

function TMGSingleFileDatabaseController.ExecuteSaveDialog: Boolean;
var
  SaveDialog: TSaveDialog;
begin
  SaveDialog := TSaveDialog.Create(Self);
  try
    ConfigureSaveDialog(SaveDialog);

    Result := SaveDialog.Execute;
    if Result then
      SaveDatabaseToFile(SaveDialog.FileName);
  finally
    SaveDialog.Free;
  end;
end;

function TMGSingleFileDatabaseController.HasDataChanged: Boolean;
begin
  Result := (FDataSet.ChangeCount > 0);
end;

procedure TMGSingleFileDatabaseController.LoadDatabaseFromFile(Filename: String);
begin
  if (Filename = '') then
    Filename := FDefaultDatabaseFilename;

  if (System.SysUtils.ExtractFilePath(Filename) = '') then
    Filename := FDatabasePath + Filename;

  FDataSet.LoadFromFile(Filename);

  FOpenDatabaseFilename := Filename;

  // we call MergeChangeLog, so that the DataSet ChangeCount is set to 0
  FDataSet.MergeChangeLog;
end;

procedure TMGSingleFileDatabaseController.NewDatabase;
begin
  FDataSet.Close;

  // create the dataset (field + index definitions are set in the component properties)
  FDataSet.CreateDataSet;
  FDataSet.Open;

  FOpenDatabaseFilename := '';

  EnsureDatabasePathExists;
end;

procedure TMGSingleFileDatabaseController.SaveDatabaseToFile(Filename: String);
begin
  if (Filename = '') then
    if (FOpenDatabaseFilename <> '') then
      Filename := FOpenDatabaseFilename
    else
      Filename := FDefaultDatabaseFilename;

  if (System.SysUtils.ExtractFilePath(Filename) = '') then
  begin
    EnsureDatabasePathExists;
    Filename := FDatabasePath + Filename;
  end;

  FDataSet.MergeChangeLog;
  FDataSet.SaveToFile(Filename, TDataPacketFormat.dfXMLUTF8);

  FOpenDatabaseFilename := Filename;
end;

procedure TMGSingleFileDatabaseController.SetApplicationTitle(Title: String);
begin
  FDatabasePath := System.IOUtils.TPath.GetDocumentsPath +
                    System.IOUtils.TPath.DirectorySeparatorChar +
                    Title +
                    System.IOUtils.TPath.DirectorySeparatorChar;

  FApplicationTitle := Title;
end;

procedure TMGSingleFileDatabaseController.UpdateDatabaseFileFilter;
begin
  FDatabaseFileFilter := FApplicationTitle + ' Data|*' + FDatabaseFileExtension;
end;

end.
