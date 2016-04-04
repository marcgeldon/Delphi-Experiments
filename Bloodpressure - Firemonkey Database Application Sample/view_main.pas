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

  Main View / Form

  Known issues:

  - last deleted record in empty dataset is still visible in the StringGrid
    already reported to Embarcadero: https://quality.embarcadero.com/browse/RSP-14093
*******************************************************************************}
unit view_main;

interface

uses
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, controller_main,
  model_main, Data.Bind.Controls, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  FMX.Layouts, Fmx.Bind.Navigator, Data.Bind.DBScope, FMX.ListBox,
  FMX.Controls.Presentation, FMX.Edit, FMX.ScrollBox, FMX.Memo, Fmx.Bind.Grid,
  Data.Bind.Grid, FMX.Grid, FMX.StdCtrls, System.Actions, FMX.ActnList,
  FMX.DateTimeCtrls, System.Classes;

type
  TfrmMain = class(TForm)
    BindSourceDB: TBindSourceDB;
    BindingsList: TBindingsList;
    editSystolic: TEdit;
    LinkControlToField1: TLinkControlToField;
    editDiastolic: TEdit;
    LinkControlToField2: TLinkControlToField;
    editPulse: TEdit;
    LinkControlToField3: TLinkControlToField;
    memoComment: TMemo;
    LinkControlToField4: TLinkControlToField;
    StringGrid: TStringGrid;
    StyleBook: TStyleBook;
    layoutDetail: TLayout;
    lblSystolic: TLabel;
    lblDiastolic: TLabel;
    lblPulse: TLabel;
    lblComment: TLabel;
    ActionList: TActionList;
    actLoad: TAction;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    actSave: TAction;
    lblDate: TLabel;
    editDate: TDateEdit;
    editTime: TTimeEdit;
    LinkControlToField6: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    lblTime: TLabel;
    actSaveAs: TAction;
    actNew: TAction;
    actAbout: TAction;
    StatusBar: TStatusBar;
    ToolBar: TToolBar;
    sbtnNew: TSpeedButton;
    sbtnLoad: TSpeedButton;
    sbtnSave: TSpeedButton;
    sbtnSaveAs: TSpeedButton;
    sbtnAbout: TSpeedButton;
    NavigatorBindSourceDB: TBindNavigator;
    lblStatusBar: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure actLoadExecute(Sender: TObject);
    procedure actSaveUpdate(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actAboutExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FController: TMainController;
  public
  published
    property Controller: TMainController read FController;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.actAboutExecute(Sender: TObject);
begin
  FController.ShowAboutBox;
end;

procedure TfrmMain.actLoadExecute(Sender: TObject);
begin
  FController.LoadDatabaseDialog;
end;

procedure TfrmMain.actNewExecute(Sender: TObject);
begin
  FController.NewDatabase;
end;

procedure TfrmMain.actSaveAsExecute(Sender: TObject);
begin
  FController.SaveDatabaseDialog;
end;

procedure TfrmMain.actSaveExecute(Sender: TObject);
begin
  FController.SaveDatabase;
end;

procedure TfrmMain.actSaveUpdate(Sender: TObject);
begin
  actSave.Enabled := FController.HasDataChanged;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FController.FormCloseQuery(Sender, CanClose);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FController := TMainController.Create(Self);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  FController.FormShow(Sender);
end;

end.

