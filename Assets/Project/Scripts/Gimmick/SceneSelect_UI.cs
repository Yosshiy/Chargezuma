using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class SceneSelect_UI : MonoBehaviour
{
    [SerializeField] Text Text;

    private void Awake()
    {
        Text.text = "";      
    }

    public void TextChange(string name)
    {
        Text.DOText(name,0.2f);
    }
}
