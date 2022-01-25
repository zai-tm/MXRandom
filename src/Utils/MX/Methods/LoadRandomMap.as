namespace MX
{
    void LoadRandomMap()
    {
        try
        {
            MX::MapInfo@ map = MX::MapInfo(API::GetAsync(CreateQueryURL())[0]);

            if (map is null){
                Log::Warn("Error while loading map");
                Log::Error(MX_NAME + " API is not responding, it must be down.", true);
                APIDown = true;
                return;
            }

            CTrackMania@ app = cast<CTrackMania>(GetApp());
            app.BackToMainMenu(); // If we're on a map, go back to the main menu else we'll get stuck on the current map
            while(!app.ManiaTitleControlScriptAPI.IsReady) {
                yield(); // Wait until the ManiaTitleControlScriptAPI is ready for loading the next map
            }
            app.ManiaTitleControlScriptAPI.PlayMap("https://"+MX_URL+"/maps/download/"+map.TrackID, "", "");
            }
        catch
        {
            Log::Warn("Error while loading map ");
            Log::Error(MX_NAME + " API is not responding, it must be down.", true);
            APIDown = true;
        }
    }

    string CreateQueryURL()
    {
        string url = "https://"+MX_URL+"/mapsearch2/search?api=on&random=1";

        if (RMC::IsRunning)
        {
            url += "&etags=23,37,40";
            url += "&lengthop=1";
            url += "&length=9";
        }
        else
        {
            if (PluginSettings::MapLengthOperator != "Exacts"){
                url += "&lengthop=" + PluginSettings::SearchingMapLengthOperators.Find(PluginSettings::MapLengthOperator);
            }
            if (PluginSettings::MapLength != "Anything"){
                url += "&length=" + PluginSettings::SearchingMapLengths.Find(PluginSettings::MapLength);
            }
            if (PluginSettings::MapTag != "Anything"){
                url += "&tags=" + PluginSettings::MapTagID;
            }
        }

        if (TM::GameEdition == TM::GameEditions::NEXT)
        {
            // prevent loading CharacterPilot maps
            url += "&vehicles=1";
        }

        return url;
    }
}