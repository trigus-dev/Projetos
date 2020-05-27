unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, SpkToolbar,
  spkt_Tab, spkt_Pane, spkt_Buttons, spkt_Checkboxes;

type

  { TForm1 }

  TForm1 = class(TForm)
    SpkCheckbox1: TSpkCheckbox;
    SpkLargeButton1: TSpkLargeButton;
    SpkLargeButton2: TSpkLargeButton;
    SpkLargeButton3: TSpkLargeButton;
    SpkPane1: TSpkPane;
    SpkPane2: TSpkPane;
    SpkPane3: TSpkPane;
    SpkRadioButton1: TSpkRadioButton;
    SpkRadioButton2: TSpkRadioButton;
    SpkSmallButton1: TSpkSmallButton;
    SpkSmallButton2: TSpkSmallButton;
    SpkSmallButton3: TSpkSmallButton;
    SpkTab1: TSpkTab;
    SpkTab2: TSpkTab;
    SpkTab3: TSpkTab;
    SpkToolbar1: TSpkToolbar;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.

