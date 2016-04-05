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
  System.Variants, Data.DB, Datasnap.DBClient, component_singlefiledatabase;

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
  private
    FDBController: TMGSingleFileDatabaseController;
  public
    property DBController: TMGSingleFileDatabaseController read FDBController;
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
  FDBController := TMGSingleFileDatabaseController.Create(Self);
  FDBController.ApplicationTitle := 'Blood pressure';
  FDBController.DatabaseFileExtension := '.bloodpressure';
  FDBController.UpdateDatabaseFileFilter;
  FDBController.DefaultDatabaseFilename := 'default' + FDBController.DatabaseFileExtension;
  FDBController.DataSet := CDSBloodpressure;
  FDBController.NewDatabase;

  // if there is already a default database, we load it
  if FileExists(FDBController.DatabasePath + FDBController.DefaultDatabaseFilename) then
    FDBController.LoadDatabaseFromFile(FDBController.DatabasePath + FDBController.DefaultDatabaseFilename);
end;

end.
