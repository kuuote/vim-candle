package main

import (
	"encoding/json"

	"github.com/hrsh7th/vim-candle/go/candle"
)

var Items []candle.Item = make([]candle.Item, 0)

func Start(process *candle.Process, paramsstr string) {
	var params map[string]interface{}
	if err := json.Unmarshal([]byte(paramsstr), &params); err != nil {
		process.Logger.Println(err)
		return
	}

	items := params["items"].([]map[string]interface{})

	go func() {
		for _, item := range items {
			Items = append(Items, item)
		}
		process.NotifyDone()
	}()
}

