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
  private
    function MessageBoxAskForSavingUnchangedData: TModalResult;
    function HasDataChangedAskAndHandleSaving: Boolean;
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

function TMainController.MessageBoxAskForSavingUnchangedData: TModalResult;
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

procedure TMainController.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := HasDataChangedAskAndHandleSaving;
end;

procedure TMainController.FormShow(Sender: TObject);
begin
  UpdateStatusBar;
end;

function TMainController.HasDataChanged: Boolean;
begin
  Result := dmMain.DBController.HasDataChanged;
end;

function TMainController.HasDataChangedAskAndHandleSaving: Boolean;
var
  DialogResult: TModalResult;
begin
  dmMain.DBController.EnsureDataIsPosted;

  // if data has changed, we have to handle the question if the user wants to save or not
  if HasDataChanged then
  begin
    DialogResult := MessageBoxAskForSavingUnchangedData;

    // if user wants to save, save and saving question is handled
    if (DialogResult = mrYes) then
    begin
      SaveDatabase;
      Result := True;
    end
    // if user don't want to save, don't save and saving question is handled
    else if (DialogResult = mrNo) then
      Result := True
    // if user cancels, saving question is not handled
    else if (DialogResult = mrCancel) then
      Result := False;
  end
  // if data has not changed, saving question is handled (no saving needed)
  else
    Result := True;
end;

procedure TMainController.LoadDatabaseDialog;
begin
  if HasDataChangedAskAndHandleSaving then
  begin
    dmMain.DBController.ExecuteOpenDialog;
    UpdateStatusBar;
  end;
end;

procedure TMainController.NewDatabase;
var
  DialogResult: TModalResult;
begin
  if HasDataChangedAskAndHandleSaving then
  begin
    dmMain.DBController.NewDatabase;
    UpdateStatusBar;
  end;
end;

procedure TMainController.SaveDatabase;
begin
  if (dmMain.DBController.OpenDatabaseFilename = '') then
    SaveDatabaseDialog
  else
    dmMain.DBController.SaveDatabaseToFile();

  UpdateStatusBar;
end;

procedure TMainController.SaveDatabaseDialog;
begin
  dmMain.DBController.ExecuteSaveDialog;
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
  frmMain.lblStatusBar.Text := dmMain.DBController.OpenDatabaseFilename;
end;

end.                                                                                       x
