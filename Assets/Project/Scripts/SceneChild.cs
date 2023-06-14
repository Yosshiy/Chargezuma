using System.Collections;
using System.Collections.Generic;
using UniRx;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneChild : MonoBehaviour
{
    private void Start()
    {
        Observable.EveryUpdate()
                  .Where(x => Input.GetKeyDown(KeyCode.Return))
                  .Subscribe(x => OriginSceneManager.instance.LoadScene("Title", "StageSelect", true))
                  .AddTo(this);
    }
}
