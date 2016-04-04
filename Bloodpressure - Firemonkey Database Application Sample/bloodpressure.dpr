{*******************************************************************************
  Blood pressure Database - Small Firemonkey Database Application Example
  Version 0.1
  use it in Embarcadero Delphi 10 Seattle Update 1

  Author: Marc Geldon, Ludwigshafen, Germany
  https://github.com/marcgeldon/delphi_experiments

  The idea behind this example is to create a small database application,
  developed in Delphi, based on Firemonkey.

  To use it as a base to discuss database application development in the
  Delphi community.

  The above author notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
  IN THE SOFTWARE.
*******************************************************************************}
program bloodpressure;

uses
  System.StartUpCopy,
  FMX.Forms,
  view_main in 'view_main.pas' {frmMain},
  model_main in 'model_main.pas' {dmMain: TDataModule},
  controller_main in 'controller_main.pas';

{$R *.res}

begin
  System.ReportMemoryLeaksOnShutdown := True;

  Application.Title := 'Blood pressure Database Application';
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
