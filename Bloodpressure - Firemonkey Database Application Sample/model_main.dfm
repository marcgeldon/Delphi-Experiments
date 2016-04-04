object dmMain: TdmMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 86
  Width = 133
  object CDSBloodpressure: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'DateTimeStamp'
        DataType = ftDateTime
      end
      item
        Name = 'Systolic'
        DataType = ftInteger
      end
      item
        Name = 'Diastolic'
        DataType = ftInteger
      end
      item
        Name = 'Pulse'
        DataType = ftInteger
      end
      item
        Name = 'Comment'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <
      item
        Name = 'CDSBloodpressureIndex1'
        Fields = 'ID'
        Options = [ixPrimary]
      end
      item
        Name = 'CDSBloodpressureIndex2'
        Fields = 'DateTimeStamp'
      end>
    Params = <>
    StoreDefs = True
    AfterInsert = CDSBloodpressureAfterInsert
    Left = 48
    Top = 16
    object CDSBloodpressureID: TAutoIncField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
    end
    object CDSBloodpressureDateTimeStamp: TDateTimeField
      FieldName = 'DateTimeStamp'
    end
    object CDSBloodpressureSystolic: TIntegerField
      FieldName = 'Systolic'
    end
    object CDSBloodpressureDiastolic: TIntegerField
      FieldName = 'Diastolic'
    end
    object CDSBloodpressurePulse: TIntegerField
      FieldName = 'Pulse'
    end
    object CDSBloodpressureComment: TStringField
      FieldName = 'Comment'
    end
  end
end
