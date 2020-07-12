using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.UserProfile;

class VeloDataFieldsView extends Ui.DataField {

    hidden var lapNumber;
    hidden var hr;
    hidden var speed;
    hidden var cadence;
    hidden var altitude;
    hidden var vam;
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
    hidden var altitudeIcon;
    hidden var gregorianLapTime;
    hidden var dayTime;
    hidden var avgSpeed;

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
		altitude = 0.0f;
		vam = 0.0f;
		avgSpeed = 0.0f;
		
		hrIcon = new Ui.Bitmap({:rezId=>Rez.Drawables.hrIcon,:locX=>2,:locY=>50-14});
		cadenceIcon = new Ui.Bitmap({:rezId=>Rez.Drawables.cadenceIcon,:locX=>65+2,:locY=>50-14});	
		speedIcon = new Ui.Bitmap({:rezId=>Rez.Drawables.speedIcon,:locX=>130+3,:locY=>50-19});	
		timeIcon = new Ui.Bitmap({:rezId=>Rez.Drawables.timeIcon,:locX=>2,:locY=>100-16});	
		distanceIcon = new Ui.Bitmap({:rezId=>Rez.Drawables.distanceIcon,:locX=>130+3,:locY=>100-17});
		altitudeIcon = new Ui.Bitmap({:rezId=>Rez.Drawables.altitudeIcon,:locX=>2,:locY=>148-14});	
		
		var options = { :seconds => 0};
        gregorianLapTime = Time.Gregorian.duration(options);	     	
    }

    // The given info object contains all the current workout.
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
        if (info has :altitude) {
        	if (info.altitude != null) {
        		altitude = info.altitude.toNumber();
        	} else {
        		altitude = 0;
        	}
        }
        if (info has :totalAscent) {
        	if (info.totalAscent != null) {
        		vam = info.totalAscent.toNumber();
        	} else {
        		vam = 0;
        	}
        }
        if (info has :averageSpeed) {
        	if (info.averageSpeed != null) {
        		avgSpeed = (info.averageSpeed * 3.6).format("%.1f");
        	} else {
        		avgSpeed = (0.0f).format("%.1f");
        	}
        }
        var today = System.getClockTime();
		dayTime = today.hour.format("%02d") + ":" + today.min.format("%02d");
		
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible. 205x148
    function onUpdate(dc) {
    	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
    	dc.clear();
                
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_WHITE);
        
        // Horizontal
        dc.drawLine(0, 50, 205, 50);
        dc.drawLine(0, 100, 205, 100);
        
        // Vertical
        dc.drawLine(65, 0, 65, 50);
        dc.drawLine(65, 100, 65, 148);
        dc.drawLine(130, 0, 130, 148);
        
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        
        // Heart Rate
        hrIcon.draw(dc);
        dc.drawText(65 - 1, 6, Gfx.FONT_NUMBER_HOT, hr, Gfx.TEXT_JUSTIFY_RIGHT);
        
        // Candence
        cadenceIcon.draw(dc);
		dc.drawText(130 - 2, 6, Gfx.FONT_NUMBER_HOT, cadence, Gfx.TEXT_JUSTIFY_RIGHT);
        
        // Speed
        //dc.drawText(170 + 2, 2, Gfx.FONT_SMALL, "Km/h", Gfx.TEXT_JUSTIFY_CENTER);
        speedIcon.draw(dc);
        dc.drawText(205 - 2, 6, Gfx.FONT_NUMBER_HOT, speed.format("%.1f"), Gfx.TEXT_JUSTIFY_RIGHT);
        
        // Time        
        //dc.drawText(102, 65 + 2, Gfx.FONT_SMALL, "Time", Gfx.TEXT_JUSTIFY_CENTER);
        timeIcon.draw(dc);
        dc.drawText(130 - 2, 50 + 6, Gfx.FONT_NUMBER_HOT, toHMS(lapTime), Gfx.TEXT_JUSTIFY_RIGHT);
        
        // Distance
        //dc.drawText(170 + 2, 65 + 2, Gfx.FONT_SMALL, "Km", Gfx.TEXT_JUSTIFY_CENTER);
        distanceIcon.draw(dc);
        dc.drawText(205 -2, 50 + 6, Gfx.FONT_NUMBER_HOT, lapDistance.format("%.1f"), Gfx.TEXT_JUSTIFY_RIGHT);        
        
        // Lap Number
        dc.drawText(2, 50 + 6, Gfx.FONT_NUMBER_MILD, lapNumber, Gfx.TEXT_JUSTIFY_LEFT);
        
        // Avg Speed
        dc.drawText(130 - 2, 124 + 2, Gfx.FONT_NUMBER_MILD, avgSpeed, Gfx.TEXT_JUSTIFY_RIGHT);
        
        // Altitude
        dc.drawText(65 - 2, 100 + 2, Gfx.FONT_NUMBER_MILD, altitude, Gfx.TEXT_JUSTIFY_RIGHT);
        
        // VAM
        dc.drawText(65 - 2, 124 + 2, Gfx.FONT_NUMBER_MILD, vam, Gfx.TEXT_JUSTIFY_RIGHT);
        altitudeIcon.draw(dc);
        
        // Day Time
        dc.drawText(205 - 2, 124 + 2, Gfx.FONT_NUMBER_MILD, dayTime, Gfx.TEXT_JUSTIFY_RIGHT);
		
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
