using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class VeloDataFieldsView extends Ui.DataField {

    hidden var lapNumber;
    hidden var hr;
    hidden var speed;
    hidden var cadence;
    hidden var altitude;
    hidden var activityTime;
    hidden var lapTime;
    hidden var lapTimeMark;
    hidden var activityDistance;
    hidden var lapDistance;
    hidden var lapDistanceMark;
    hidden var hrIcon;
    hidden var timeIcon;
    hidden var speedIcon;
    hidden var cadenceIcon;
    hidden var distanceIcon;
    hidden var x0, x1, x2, x3, x4, x5;
    hidden var y0, y1, y2, y3;
    hidden var gregorianLapTime;

    function initialize() {
        DataField.initialize();
        lapNumber = 1;
      	hr = 0;
      	speed = 0.0f;
      	cadence = 0;
		activityTime = 0;
		lapTime = 0;
		lapTimeMark = 0;
		activityDistance = 0.0f;
		lapDistance = 0.0f; 
		lapDistanceMark = 0.0f;
		x0 = 18;
		x1 = 55;
		x2 = 85;
		x3 = 120;
		x4 = 157;
		x5 = 203;
		y0 = 2;
		y1 = 47;
		y2 = 78;
		y3 = 122;
		
		cadenceIcon = new Ui.Bitmap({:rezId=>Rez.Drawables.cadenceIcon,:locX=>x0,:locY=>y1});
		hrIcon = new Ui.Bitmap({:rezId=>Rez.Drawables.hrIcon,:locX=>x2,:locY=>y1});
		speedIcon = new Ui.Bitmap({:rezId=>Rez.Drawables.speedIcon,:locX=>x4,:locY=>y1});
		timeIcon = new Ui.Bitmap({:rezId=>Rez.Drawables.timeIcon,:locX=>x1,:locY=>y3});
		distanceIcon = new Ui.Bitmap({:rezId=>Rez.Drawables.distanceIcon,:locX=>x4,:locY=>y3});	
		
		var options = { :seconds => 0};
        gregorianLapTime = Time.Gregorian.duration(options);	     	
    }

    // The given info object contains all the current workout
    // information. Calculate a value and save it locally in this method.
    function compute(info) {
        // See Activity.Info in the documentation for available information.
        if(info has :currentHeartRate){
            if(info.currentHeartRate != null){
                hr = info.currentHeartRate;
            } else {
                hr = 0;
            }
        }
        if (info has :currentSpeed) {
        	if (info.currentSpeed != null) {
        		speed = info.currentSpeed * 3.6;
        	} else {
        		speed = 0.0f;
        	}
        }
        if (info has :currentCadence) {
        	if (info.currentCadence != null) {
        		cadence = info.currentCadence;
        	} else {
        		cadence = 0;
        	}
        }
        if (info has :timerTime) {
        	if (info.timerTime != null) {
        		activityTime = info.timerTime;
        		lapTime = activityTime - lapTimeMark;
        	} else {
        		activityTime = 0;
        		lapTime = 0;
        	}
        }
        if (info has :elapsedDistance) {
        	if (info.elapsedDistance != null) {
        		activityDistance = info.elapsedDistance/1000;
        		lapDistance = activityDistance - lapDistanceMark;
        	} else {
        		lapDistance = 0.0f;
        	}
        }
        
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible. 205x148
    function onUpdate(dc) {
    	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
    	dc.clear();
                
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_WHITE);
        dc.drawLine(0, y2-5, 205, y2-5);
        dc.drawLine(x1+5, 0, x1+5, 74);
        dc.drawLine(x3+5, 0, x3+5, 148);
        
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        cadenceIcon.draw(dc);
        dc.drawText(x1, y0, Gfx.FONT_NUMBER_HOT, cadence, Gfx.TEXT_JUSTIFY_RIGHT);
        
        hrIcon.draw(dc);
        dc.drawText(x3, y0, Gfx.FONT_NUMBER_HOT, hr, Gfx.TEXT_JUSTIFY_RIGHT);
        
        speedIcon.draw(dc);
        dc.drawText(x5, y0, Gfx.FONT_NUMBER_HOT, speed.format("%.1f"), Gfx.TEXT_JUSTIFY_RIGHT);
        
        timeIcon.draw(dc);
        dc.drawText(x3, y2, Gfx.FONT_NUMBER_HOT, toHMS(lapTime), Gfx.TEXT_JUSTIFY_RIGHT);
        
        distanceIcon.draw(dc);
        dc.drawText(x5, y2, Gfx.FONT_NUMBER_HOT, lapDistance.format("%.1f"), Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(2, y2, Gfx.FONT_NUMBER_MILD, lapNumber, Gfx.TEXT_JUSTIFY_LEFT);
        
    }
    
    // This is called each time a lap is created.
    function onTimerLap() {
        lapNumber++;
        lapTime = 0;
        lapTimeMark = activityTime;
        lapDistance = 0.0f;
        lapDistanceMark = activityDistance;
    }
    
    // The timer was reeset, so reset all our tracking variables
    function onTimerReset() {
        lapNumber = 1;
    }
    
    function toHMS(ms) {
    	var secs = ms/1000;
		var hr = secs/3600;
		var min = (secs-(hr*3600))/60;
		var sec = secs%60;
		if(hr!=0) {
			return hr.format("%d")+":"+min.format("%02d")+":"+sec.format("%02d");
		} else {
			return min.format("%02d")+":"+sec.format("%02d");
		}
	}

}
