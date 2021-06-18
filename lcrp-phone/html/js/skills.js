SetupSkills = function(skills) {    
    if (skills != null) {
        document.getElementById('MentalState').innerHTML = skills['mental_state']
        document.getElementById('Stamina').innerHTML = skills['stamina']
        document.getElementById('Strength').innerHTML = skills['strength']
        document.getElementById('Driving').innerHTML = skills['driving']
        document.getElementById('Flying').innerHTML = skills['flying']
        document.getElementById('Stealth').innerHTML = skills['stealth']
        document.getElementById('LungCapacity').innerHTML = skills['lung_capacity']
        document.getElementById('Shooting').innerHTML = skills['shooting']
    }
}
