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

  Main Model / Datamodule
*******************************************************************************}
unit model_main;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.DateUtils,
  System.Variants, Data.DB, Datasnap.DBClient;

type
  TdmMain = class(TDataModule)
    CDSBloodpressure: TClientDataSet;
    CDSBloodpressureSystolic: TIntegerField;
    CDSBloodpressureDiastolic: TIntegerField;
    CDSBloodpressurePulse: TIntegerField;
    CDSBloodpressureComment: TStringField;
    CDSBloodpressureDateTimeStamp: TDateTimeField;
    CDSBloodpressureID: TAutoIncField;
    procedure DataModuleCreate(Sender: TObject);
    procedure CDSBloodpressureAfterInsert(DataSet: TDataSet);
  const
    DefaultDatabasePathname = 'Blood pressure';
    DefaultDatabaseFilename = 'database.bloodpressure';
  private
    FOpenDatabaseFilename: String;
    FDefaultDatabasePath: String;
  public
    procedure NewDatabase;
    procedure LoadDatabaseFromFile(Filename: String = '');
    procedure SaveDatabaseToFile(Filename: String = '');
    procedure EnsureDefaultDatabasePathExists;
    procedure EnsureDataIsPosted;

    property OpenDatabaseFilename: String read FOpenDatabaseFilename;
  end;

var
  dmMain: TdmMain;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TdmMain.CDSBloodpressureAfterInsert(DataSet: TDataSet);
begin
  CDSBloodpressureDateTimeStamp.AsDateTime := Now;
end;

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
  NewDatabase;

  FDefaultDatabasePath :=  System.IOUtils.TPath.GetDocumentsPath +
                    System.IOUtils.TPath.DirectorySeparatorChar +
                    DefaultDatabasePathname +
                    System.IOUtils.TPath.DirectorySeparatorChar;

  EnsureDefaultDatabasePathExists;

  // if there is already a default database, we load it
  if FileExists(FDefaultDatabasePath + DefaultDatabaseFilename) then
    LoadDatabaseFromFile();
end;

procedure TdmMain.EnsureDataIsPosted;
begin
  if (CDSBloodpressure.State in [TDataSetState.dsEdit, TDataSetState.dsInsert]) then
    CDSBloodpressure.Post;
end;

procedure TdmMain.EnsureDefaultDatabasePathExists;
begin
  // if the default database path does not exist, we create it (in the user document directory)
  if not DirectoryExists(FDefaultDatabasePath) then
    ForceDirectories(FDefaultDatabasePath);
end;

procedure TdmMain.LoadDatabaseFromFile(Filename: String);
begin
  if (Filename = '') then
    Filename := DefaultDatabaseFilename;

  if (System.SysUtils.ExtractFilePath(Filename) = '') then
    Filename := FDefaultDatabasePath + Filename;

  CDSBloodpressure.LoadFromFile(Filename);
  FOpenDatabaseFilename := Filename;

  // we call MergeChangeLog, so that the DataSet ChangeCount is set to 0
  CDSBloodpressure.MergeChangeLog;
end;

procedure TdmMain.NewDatabase;
begin
  CDSBloodpressure.Close;

  // create the dataset (field + index definitions are set in the component properties)
  CDSBloodpressure.CreateDataSet;
  CDSBloodpressure.Open;

  FOpenDatabaseFilename := '';
end;

procedure TdmMain.SaveDatabaseToFile(Filename: String);
begin
  if (Filename = '') then
    if (FOpenDatabaseFilename <> '') then
      Filename := FOpenDatabaseFilename
    else
      Filename := DefaultDatabaseFilename;

  if (System.SysUtils.ExtractFilePath(Filename) = '') then
  begin
    EnsureDefaultDatabasePathExists;
    Filename := FDefaultDatabasePath + Filename;
  end;

  CDSBloodpressure.MergeChangeLog;
  CDSBloodpressure.SaveToFile(Filename, TDataPacketFormat.dfXMLUTF8);

  FOpenDatabaseFilename := Filename;
end;

end.
