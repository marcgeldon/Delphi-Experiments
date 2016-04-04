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

  Controller for Main View / Form
*******************************************************************************}
unit controller_main;

interface
uses System.SysUtils, System.Classes, System.UITypes, FMX.Forms, FMX.Dialogs,
model_main, Windows;

type
  TMainController = class(TComponent)
  const
    DefaultFileExtension = '.bloodpressure';
    DefaultFileFilter = 'Blood pressure Data|*.bloodpressure';
  private
    function AskForSavingUnchangedData: TModalResult;
    procedure UpdateStatusBar;
  public
    constructor Create(AOwner: TComponent); override;

    function HasDataChanged: Boolean;
    procedure NewDatabase;
    procedure LoadDatabaseDialog;
    procedure SaveDatabase;
    procedure SaveDatabaseDialog;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);

    procedure ShowAboutBox;
  end;

implementation
uses view_main;

{ TMainController }

function TMainController.AskForSavingUnchangedData: TModalResult;
begin
  Result := FMX.Dialogs.MessageDlg('Do you want to save the changed data?',
                                   TMsgDlgType.mtConfirmation,
                                   [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo, TMsgDlgBtn.mbCancel], 0);
end;

constructor TMainController.Create(AOwner: TComponent);
begin
  inherited;

  if not Assigned(dmMain) then
    dmMain := TdmMain.Create(Application);
end;

procedure TMainController.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  dialogresult: TModalResult;
begin
  dmMain.EnsureDataIsPosted;

  if HasDataChanged then
  begin
    dialogresult := AskForSavingUnchangedData;

    if (dialogresult = mrYes) then
      SaveDatabase
    else if (dialogresult = mrCancel) then
      CanClose := False;
  end;
end;

procedure TMainController.FormShow(Sender: TObject);
begin
  UpdateStatusBar;
end;

function TMainController.HasDataChanged: Boolean;
begin
  Result := (dmMain.CDSBloodpressure.ChangeCount > 0);
end;

procedure TMainController.LoadDatabaseDialog;
var
  OpenDialog: TOpenDialog;
  dialogresult: TModalResult;
begin
  dmMain.EnsureDataIsPosted;

  if HasDataChanged then
  begin
    dialogresult := AskForSavingUnchangedData;

    if (dialogresult = mrYes) then
      SaveDatabase
    else if (dialogresult = mrCancel) then
      Exit;
  end;

  OpenDialog := TOpenDialog.Create(Self);

  try
    OpenDialog.DefaultExt := DefaultFileExtension;
    OpenDialog.Filter := DefaultFileFilter;

    if OpenDialog.Execute then
      if System.SysUtils.FileExists(OpenDialog.FileName) then
        dmMain.LoadDatabaseFromFile(OpenDialog.FileName);
  finally
    OpenDialog.Free;
  end;

  UpdateStatusBar;
end;

procedure TMainController.NewDatabase;
var
  dialogresult: TModalResult;
begin
  dmMain.EnsureDataIsPosted;

  if HasDataChanged then
  begin
    dialogresult := AskForSavingUnchangedData;

    if (dialogresult = mrYes) then
      SaveDatabase
    else if (dialogresult = mrCancel) then
      Exit;
  end;

  dmMain.NewDatabase;
  UpdateStatusBar;
end;

procedure TMainController.SaveDatabase;
begin
  if (dmMain.OpenDatabaseFilename = '') then
    SaveDatabaseDialog
  else
    dmMain.SaveDatabaseToFile();

  UpdateStatusBar;
end;

procedure TMainController.SaveDatabaseDialog;
var
  SaveDialog: TSaveDialog;
begin
  SaveDialog := TSaveDialog.Create(Self);

  try
    SaveDialog.DefaultExt := DefaultFileExtension;
    SaveDialog.Filter := DefaultFileFilter;
    SaveDialog.Options := SaveDialog.Options + [System.UITypes.TOpenOption.ofOverwritePrompt, System.UITypes.TOpenOption.ofExtensionDifferent];
    SaveDialog.InitialDir := ExtractFilePath(dmMain.OpenDatabaseFilename);
    SaveDialog.FileName := ExtractFileName(dmMain.OpenDatabaseFilename);

    if SaveDialog.Execute then
      dmMain.SaveDatabaseToFile(SaveDialog.FileName);
  finally
    SaveDialog.Free;
  end;

  UpdateStatusBar;
end;

procedure TMainController.ShowAboutBox;
begin
  FMX.Dialogs.ShowMessage('Blood pressure Database' + #13#10 +
                          'Small Firemonkey Database Example' + #13#10 +
                          #13#10 +
                          'Author: Marc Geldon, Ludwigshafen, Germany' + #13#10 +
                          'https://github.com/marcgeldon/delphi_experiments' + #13#10 +
                          #13#10 +
                          'The idea behind this example is to create a small database application, developed in Delphi, based on Firemonkey. ' +
                          'To use it as a base to discuss database application development in the Delphi community.' + #13#10 +
                          #13#10 +
                          'The above author notice and this permission notice shall be included in all copies or substantial portions of the Software.' + #13#10 +
                          #13#10 +
                          'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. ' +
                          'IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION ' +
                          'WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.');
end;

procedure TMainController.UpdateStatusBar;
begin
  frmMain.lblStatusBar.Text := dmMain.OpenDatabaseFilename;
end;

end.                                                                                             x
